locals {
  # This generates a unique name by combining a prefix with an MD5 hash of the current timestamp
  generated_bucket_name = "serverless-scribe-${substr(md5(timestamp()), 0, 8)}"
  frontend_path         = "../frontend"
  backend_path          = "../api"
}