db_parameter_groups = {
  primary_db_parameter_group = {
    family      = "mysql8.0"
    description = "Primary DB Parameter Group for MySQL 8.0"
    parameters = [
      {
        name  = "character_set_server"
        value = "utf8mb4"
      },
      {
        name  = "collation_server"
        value = "utf8mb4_unicode_ci"
      },
      {
        name  = "max_connections"
        value = "200"
      }
    ]
    create_before_destroy = true
    tags = {
      Name = "PrimaryDBParameterGroup"
    }
  }

  secondary_db_parameter_group = {
    family      = "postgres13"
    description = "Secondary DB Parameter Group for PostgreSQL 13"
    parameters = [
      {
        name  = "work_mem"
        value = "4MB"
      },
      {
        name  = "maintenance_work_mem"
        value = "64MB"
      },
      {
        name  = "max_parallel_workers"
        value = "2"
      }
    ]
    create_before_destroy = true
    tags = {
      Name = "SecondaryDBParameterGroup"
    }
  }
}
