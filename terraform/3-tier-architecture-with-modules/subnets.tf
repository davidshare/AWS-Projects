variable "subnets" {
  description = "Map of subnets with their configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
    vpc_name          = string
    tags              = map(string)
  }))
}

# Module call for subnets
module "subnets" {
  for_each = var.subnets

  source = "../../../terraform-aws-modules/subnets/"

  vpc_id                  = module.vpc[each.value.vpc_name].vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public
  tags                    = each.value.tags
}
