variable "instance_profiles" {
  description = "A map of maps, where each map defines the values for an IAM instance profile."
  type = map(object({
    name : string
    role : string
    tags : map(string)
  }))
}


module "instance_profile" {
  for_each = var.instance_profiles

  source = "../../../terraform-aws-modules/iam_instance_profile"

  name = each.value.name
  role = module.roles[each.value.role].iam_role_name
  tags = merge(each.value.tags, local.tags)
}