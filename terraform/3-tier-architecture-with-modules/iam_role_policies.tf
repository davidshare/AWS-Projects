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

  source = "github.com/davidshare/terraform-aws-modules//iam_role_policy?ref=iam_role_policy-v1.0.0"

  name   = each.value.name
  role   = module.roles[each.value.role].name
  policy = jsonencode(each.value.policy)
}
