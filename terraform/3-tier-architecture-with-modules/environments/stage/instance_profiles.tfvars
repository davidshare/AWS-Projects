instance_profiles = {
  "web_profile" = {
    name = "web"
    role = "web-instances-role"
    tags = {
      "Name" = "web-profile"
    }
  },
  "backend_profile" = {
    name = "backend"
    role = "backend-instances-role"
    tags = {
      "Name" = "backend-profile"
    }
  }
}