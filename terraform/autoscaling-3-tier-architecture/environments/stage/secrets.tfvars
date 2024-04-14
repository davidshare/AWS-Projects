db_instances_secrets = {
  db_primary = {
    db_name  = "tersudb"
    username = "tersuadmin"
    password = "Create2023tersu34"
  }
}

launch_template_secrets = {
  backend = {
    db_name  = "tersudb"
    username = "tersuadmin"
    password = "Create2023tersu34"
    name     = "namecreator"
  }
}