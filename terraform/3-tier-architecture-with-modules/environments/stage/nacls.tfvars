network_acls = {
  primary_public = {
    vpc     = "main"
    subnets = ["primary_public_1", "primary_public_2"]
    tags    = { Name = "Primary Public ACL" }
  }
  primary_backend_private = {
    vpc     = "main"
    subnets = ["primary_backend_private_1", "primary_backend_private_2"]
    tags    = { Name = "Primary Backend Private ACL" }
  }
  primary_db_private = {
    vpc     = "main"
    subnets = ["primary_db_private_1", "primary_db_private_2"]
    tags    = { Name = "Primary DB Private ACL" }
  }
}