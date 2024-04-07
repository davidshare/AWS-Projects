variable "subnet_names" {
  type = list(string)
  # default = ["subnet-1", "subnet-2"]  # List of subnet names to fetch
}

locals {
  subnet_ids_map = {
    for name in var.subnet_names : name => data.aws_subnet.subnets[name].id
  }
}

data "aws_subnet" "subnets" {
  for_each = toset(var.subnet_names)

  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}

output "subnet_ids" {
  value = local.subnet_ids_map
}
