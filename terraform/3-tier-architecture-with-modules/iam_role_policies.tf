variable "role_policies" {
  description = "Map of role names to policy configurations"
  type = map(object({
    name = string
    role = string
    policy = object({
      Version = string
      Statement = list(object({
        Effect   = string
        Action   = list(string)
        Resource = list(string)
      }))
    })
  }))
}

module "role_policies" {
  for_each = var.role_policies

  source = "../../../terraform-aws-modules/iam_role_policy"

  name   = each.value.name
  role   = module.roles[each.value.role].iam_role_name
  policy = jsonencode(each.value.policy)
}
