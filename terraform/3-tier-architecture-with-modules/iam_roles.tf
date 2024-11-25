variable "roles" {
  description = "Map of role names to role configurations"
  type = map(object({
    name        = string
    path        = string
    description = string
    assume_role_policy = object({ # Changed back to object
      Version = string
      Statement = list(object({
        Effect = string
        Principal = object({
          Service = string
        })
        Action = string
      }))
    })
    max_session_duration  = number
    force_detach_policies = bool
    tags                  = map(string)
  }))
}


module "roles" {
  for_each = var.roles

  source = "github.com/davidshare/terraform-aws-modules//iam_role?ref=iam_role-v1.0.0"

  name                  = each.value.name
  path                  = each.value.path
  description           = each.value.description
  assume_role_policy    = jsonencode(each.value.assume_role_policy)
  max_session_duration  = each.value.max_session_duration
  force_detach_policies = each.value.force_detach_policies
  tags                  = merge(each.value.tags, local.tags)
}
