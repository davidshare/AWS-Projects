db_instances = {
  primary_db = {
    identifier                            = "primary-db"
    instance_class                        = "db.t3.micro"
    engine                                = "mysql"
    engine_version                        = "8.0.32"
    username_secret                       = "primary_db_secret_version"
    password_secret                       = "primary_db_secret_version"
    allocated_storage                     = 10
    multi_az                              = false
    availability_zone                     = "us-east-1a"
    backup_retention_period               = 1
    db_subnet_group                       = "primary_db_subnet_group"
    manage_master_user_password           = null
    performance_insights_enabled          = false
    performance_insights_retention_period = null
    vpc_security_groups                   = ["database"]
    tags = {
      Role = "primary"
    }
  }

  replica_db = {
    identifier                            = "replica-db"
    instance_class                        = "db.t3.micro"
    engine                                = "mysql"
    engine_version                        = "8.0.32"
    replicate_source_db                   = "primary-db"
    username_secret                       = null
    password_secret                       = null
    allocated_storage                     = 10
    multi_az                              = false
    availability_zone                     = "us-east-1b"
    db_subnet_group                       = null
    performance_insights_enabled          = false
    performance_insights_retention_period = null
    manage_master_user_password           = null
    vpc_security_groups                   = ["database"]
    tags = {
      Role = "replica"
    }
  }
}