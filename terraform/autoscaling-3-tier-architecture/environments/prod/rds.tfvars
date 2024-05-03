database_subnet_groups = {
  primary_db = {
    name        = "primary-database-subnet-group"
    subnets     = ["Database-1", "Database-2"]
    description = "primary database"
    tags = {
      Name        = "Primary-db"
      Description = "the primary database for tersu"
    }
  }
}

db_instances = {
  db_primary = {
    identifier              = "primary"
    allocated_storage       = 10
    engine                  = "postgres"
    engine_version          = "14.11"
    instance_class          = "db.t3.micro"
    skip_final_snapshot     = true
    availability_zone       = "us-east-1b"
    db_subnet_group         = "primary_db"
    backup_retention_period = 1
    multi_az                = false
    vpc_sgs                 = ["Database-Security-Group"],
    tags = {
      Name = "My Postgres DB"
    }
  }
}

replica_db_instances = {
  db_primary_replica = {
    identifier              = "primary-replica"
    instance_class          = "db.t3.micro"
    skip_final_snapshot     = true
    backup_retention_period = 7
    replicate_source_db     = "db_primary"
  }
}