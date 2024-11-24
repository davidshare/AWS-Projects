secretsmanager_secrets = {
  primary_db_secret = {
    name        = "primary-db-secret"
    description = "Secret for the primary MySQL instance credentials"
    tags = {
      Role = "primary"
    }
  }
}

secretsmanager_secret_versions = {
  primary_db_secret_version = {
    secret = "primary_db_secret"
    secret_string = {
      username = "admin"
      password = "securepassword123"
    }
    version_stages = ["AWSCURRENT"]
  }
}
