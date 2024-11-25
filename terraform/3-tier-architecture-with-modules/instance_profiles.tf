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

  source = "github.com/davidshare/terraform-aws-modules//iam_instance_profile?ref=iam_instance_profile-v1.0.0"

  name = each.value.name
  role = module.roles[each.value.role].name
  tags = merge(each.value.tags, local.tags)
}