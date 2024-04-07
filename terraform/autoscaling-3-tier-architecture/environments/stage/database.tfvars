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
    allocated_storage    = 10
    engine               = "posgres"
    engine_version       = "14.7"
    instance_class       = "db.t2.micro"
    db_name              = "postgresdb"
    username             = "username"
    password             = "password"
    parameter_group_name = "default.postgres12"
    skip_final_snapshot  = true
    availability_zone    = "us-east-1b"
    db_subnet_group      = "primary_db"
    multi_az                    = false 
    vpc_sgs              = ["Database-Security-Group"],
    tags = {
      Name = "My Postgres DB"
    }
  }
}

replica_db_instances = {
  db_primary_replica = {
    instance_class          = "db.t2.micro"
    skip_final_snapshot     = true
    backup_retention_period = 7
    replicate_source_db     = "db_primary"
  }
}