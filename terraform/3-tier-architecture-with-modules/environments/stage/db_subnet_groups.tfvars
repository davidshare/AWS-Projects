db_subnet_groups = {
  primary_db_subnet_group = {
    name        = "primary-db-subnet-group"
    description = "Subnet group for the primary database"
    subnets     = ["primary_db_private_1", "primary_db_private_2"]
    tags = {
      "Name" = "Primary db subnet group"
    }
  }
}
