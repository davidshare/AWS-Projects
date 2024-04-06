db_subnet_groups = {
  db = {
    name        = "main"
    subnet_ids  = []
    description = "primary database"
    tags = {
      Name = "Primary db"
    }
  }
}

db_instances = {
  db_primary = {
    allocated_storage      = 10
    engine                 = "posgres"
    engine_version         = "14.7"
    instance_class         = "db.t2.micro"
    db_name                = "postgresdb"
    username               = "username"
    password               = "password"
    parameter_group_name   = "default.postgres12"
    skip_final_snapshot    = true
    availability_zone      = "us-east-1b"
    db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
    vpc_security_group_ids = [aws_security_group.database-security-group.id],
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