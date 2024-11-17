launch_template_configs = {
  frontend = {
    name          = "frontend"
    instance_type = "t3.micro"              # Free Tier eligible
    image_id      = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (adjust as needed)
    user_data     = <<-EOF
                    #!/bin/bash
                    yum update -y
                    yum install -y httpd
                    systemctl start httpd
                    systemctl enable httpd
                    echo "<h1>Frontend Server</h1>" > /var/www/html/index.html
                    EOF
    block_device_mappings = [
      {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 10 # Reduced to stay under 30 GiB total
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    ]
    network_interfaces = [
      {
        associate_public_ip_address = true
        security_groups             = ["web"] # Replace with your security group ID
      }
    ]
    iam_instance_profile = {
      name = "frontend-instance-profile"
    }
    monitoring = {
      enabled = true
    }
    tag_specifications = [
      {
        resource_type = "instance"
        tags = {
          Name = "Frontend-Server"
          Tier = "Frontend"
        }
      }
    ]
    metadata_options = {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 1
    }
    credit_specification = {
      cpu_credits = "standard" # Standard credits are free-tier eligible
    }
  },
  backend = {
    name          = "backend"
    instance_type = "t3.micro"              # Free Tier eligible
    image_id      = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (adjust as needed)
    user_data     = <<-EOF
                    #!/bin/bash
                    yum update -y
                    yum install -y docker
                    systemctl start docker
                    systemctl enable docker
                    docker run -d -p 8080:8080 my-backend-app:latest
                    EOF
    block_device_mappings = [
      {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 20 # Reduced to stay under 30 GiB total
          volume_type           = "gp3"
          encrypted             = true
          delete_on_termination = true
        }
      }
    ]
    network_interfaces = [
      {
        associate_public_ip_address = false
        security_groups             = ["backend"] # Replace with your security group ID
      }
    ]
    iam_instance_profile = {
      name = "backend-instance-profile"
    }
    monitoring = {
      enabled = true
    }
    tag_specifications = [
      {
        resource_type = "instance"
        tags = {
          Name = "Backend-Server"
          Tier = "Backend"
        }
      }
    ]
    metadata_options = {
      http_endpoint               = "enabled"
      http_tokens                 = "required"
      http_put_response_hop_limit = 1
    }
    credit_specification = {
      cpu_credits = "standard" # Standard credits are free-tier eligible
    }
  }
}
