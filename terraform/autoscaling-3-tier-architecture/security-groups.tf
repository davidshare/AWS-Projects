variable "frontend_security_group_names" {
  type    = list(string)
  default = ["Frontend-Security-Group"]
}

variable "database_security_group_names" {
  type    = list(string)
  default = ["Database-Security-Group"]
}

resource "aws_security_group" "alb_security_group" {
  name        = "ALB-Security-Group"
  description = "Enable http/https access on port 80/443"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "ALB Security Group" }, local.tags)
}

resource "aws_security_group" "ssh_security_group" {
  name        = "SSH-Security-Group"
  description = "Enable SSH access on port 22"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "SSH Security Group" }, local.tags)
}

resource "aws_security_group" "frontend_security_group" {
  for_each    = toset(var.frontend_security_group_names)

  name        = each.key
  description = "Enable http, https, and ssh access on ports 80, 443, and 22 respectively"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "https access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description     = "ssh access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "Frontend Security Group" }, local.tags)
}

resource "aws_security_group" "database_security_group" {
for_each    = toset(var.database_security_group_names)
  
  name        = "Database-Security-Group"
  description = "Enable Postgresql access on port 5432"
  vpc_id      = data.aws_vpc.selected.id


  ingress {
    description     = "https access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_security_group["Frontend-Security-Group"].id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "Database Security Group" }, local.tags)
}