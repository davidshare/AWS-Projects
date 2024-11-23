variable "db_parameter_groups" {
  description = "Map of DB Parameter Group configurations"
  type = map(object({
    family      = string
    description = string
    parameters = list(object({
      name  = string
      value = string
    }))
    tags = map(string)
  }))
}

module "db_parameter_groups" {
  for_each = var.db_parameter_groups

  source = "../../../terraform-aws-modules/db_parameter_group"

  family      = each.value.family
  description = each.value.description
  parameters  = each.value.parameters
  tags        = merge(each.value.tags, local.tags)

}
