roles = {
  "web-instances-role" = {
    name        = "web-role"
    path        = "/service/web/"
    description = "Role for web servers with necessary permissions"
    assume_role_policy = {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
    max_session_duration  = 3600
    force_detach_policies = true
    tags = {
      Name = "WebRole"
    }
  },
  "backend-instances-role" = {
    name        = "backend-role"
    path        = "/service/backend/"
    description = "Role for backend services with necessary permissions"
    assume_role_policy = {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        }
      ]
    }
    max_session_duration  = 3600
    force_detach_policies = true
    tags = {
      Name = "BackendRole"
    }
  }
}
