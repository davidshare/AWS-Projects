secretsmanager_secrets = {
  primary_db_secret = {
    name        = "primary-db-secret"
    description = "Secret for the primary MySQL instance credentials"
    tags = {
      Role = "primary"
    }
  }

  replica_db_secret = {
    name        = "replica-db-secret"
    description = "Secret for the replica MySQL instance credentials"
    tags = {
      Role = "replica"
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
