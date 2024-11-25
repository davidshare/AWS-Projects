variable "secretsmanager_secrets" {
  description = "Map of Secrets Manager Secret configurations for storing secret metadata"
  type = map(object({
    name        = string
    description = string
    tags        = map(string)
  }))
}

variable "secretsmanager_secret_versions" {
  description = "Map of Secrets Manager Secret Version configurations for storing secret values"
  type = map(object({
    secret         = string
    secret_string  = map(string)
    version_stages = list(string)
  }))
}



module "secretsmanager_secrets" {
  for_each = var.secretsmanager_secrets

  source = "github.com/davidshare/terraform-aws-modules//secretsmanager_secret?ref=secretsmanager_secret-v1.0.0"

  name        = each.value.name
  description = each.value.description
  tags        = each.value.tags
}

module "secretsmanager_secret_versions" {
  for_each = var.secretsmanager_secret_versions

  source = "github.com/davidshare/terraform-aws-modules//secretsmanager_secret_version?ref=secretsmanager_secret_version-v1.0.0"

  secret_id      = module.secretsmanager_secrets[each.value.secret].arn
  secret_string  = jsonencode(each.value.secret_string)
  version_stages = each.value.version_stages
}

