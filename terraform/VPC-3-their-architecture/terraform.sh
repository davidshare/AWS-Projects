#!/usr/bin/env bash

#  Copyright (c) 2022 cloudkite.io
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.

VERSION="2023.01.31a"

##### terraform.sh #####
# This is an opinionated terraform state manager.
########################
TERRAFORM_BINARY=${TERRAFORM_BINARY:-"/usr/bin/env terraform"}

# We have to support Bash <4, so use indirection
ENVIRONMENTS=(stage prod)
TERRAFORM_BUCKETS=(useearna-stage-infrastructure useearna-prod-infrastructure)

COMMANDS=("apply" "destroy" "import" "init" "plan" "refresh" "state")
TEMPFILES=()
ENVIRONMENT=""

finish() {
  local exitcode="$?"
  echo ""
  echo "Begin cleanup..."
  for f in "${TEMPFILES[@]}"; do
    echo "Deleting symlink ${f}..."
    rm "${f}"
  done
  for f in "${DISABLEDFILES[@]}"; do
    echo "Changing ${f} back to original name..."
    mv "${f}" "$(basename "${f}" ".disabled")"
  done
  echo "Done."
  echo ""
  return $exitcode
}

elementIn() {
  local needle="${1}"
  shift
  local haystack=("${@}")

  for e in "${haystack[@]}"; do
    if [[ "${needle}" == "${e}" ]]; then
      return 0
    fi
  done
  return 1
}

showHelp() {
  local commands
  local environments
  commands=$(echo "${COMMANDS[*]}>" | tr " " "|")
  environments=$(echo "${ENVIRONMENTS[*]}>" | tr " " "|")
  echo "Usage: "
  echo "${0} <${environments}> <${commands}>"
  echo ""
  kill -1 $$
}

symlinkEnvFiles() {
  shopt -s nullglob
  TEMPFILES=()
  for f in *."${ENVIRONMENT}"; do
    new_name="${f}.$(date +%s).tf"
    echo "Temporarily symlinking ${f} to ${new_name}"
    ln -s "${f}" "${new_name}"
    TEMPFILES+=("${new_name}")
  done
  shopt -u nullglob
}

disableFiles() {
  # This looks for terraform files with a comment that matches:
  # # DISABLED_ENVIRONMENTS: <env1>, <env2>
  # If current env is in the list, we rename the .tf file to append .disabled
  shopt -s nullglob
  DISABLEDFILES=()
  for f in *.tf; do
    if grep -q "^# DISABLED_ENVIRONMENTS: .*\(${ENVIRONMENT}\).*" "${f}"; then
      new_name="${f}.disabled"
      echo "Temporarily renaming disabled ${f} to ${new_name}"
      mv "${f}" "${new_name}"
      DISABLEDFILES+=("${new_name}")
    fi
  done
  shopt -u nullglob
}

terraformInit() {
  local env="${1}"
  for i in "${!ENVIRONMENTS[@]}"; do
    [[ "${ENVIRONMENTS[$i]}" = "${env}" ]] && break
  done
  local bucket=${TERRAFORM_BUCKETS[$i]}
  if [ -f ".terraform/terraform.tfstate" ]; then
    current_bucket=$(jq -r '.["backend"]["config"]["bucket"]' <.terraform/terraform.tfstate)
    if [[ $bucket == "${current_bucket}" ]]; then
      echo "Terraform initialized: env=${env} | bucket=${current_bucket}"
      return
    fi
  fi
  echo "Running terraform init..."
  if ! ${TERRAFORM_BINARY} init -reconfigure -backend-config="environments/${env}/backend-s3.hcl"; then
    finish
    kill -1 $$
  fi
}

main() {

  ENVIRONMENT="${1}"
  if ! elementIn "${ENVIRONMENT}" "${ENVIRONMENTS[@]}"; then
    echo "Invalid environment specified."
    echo ""
    showHelp
  fi

  symlinkEnvFiles
  disableFiles

  terraformInit "${ENVIRONMENT}"

  shift
  command="${1}"
  if ! elementIn "${command}" "${COMMANDS[@]}"; then
    echo "Invalid command specified."
    echo ""
    showHelp
  fi

  shift
  if [[ "${command}" != "init" ]]; then
    echo ""
    echo "Current ${TERRAFORM_BINARY} environment: Environment=${ENVIRONMENT}"
    echo ""
    if [[ "${command}" != "state" ]]; then
      tf_command="${TERRAFORM_BINARY} ${command}"
      for tfvarfile in ./environments/${ENVIRONMENT}/*.tfvars; do
        # support arbitrary tfvarfiles
        tf_command="${tf_command} -var-file=$tfvarfile"
      done
    else tf_command="${TERRAFORM_BINARY} ${command}"
    fi
    eval "${tf_command} $*"
  fi
}

main "$@"

trap finish EXIT
