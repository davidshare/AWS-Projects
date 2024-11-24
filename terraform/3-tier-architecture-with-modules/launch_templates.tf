variable "launch_template_configs" {
  description = "Map of launch template configurations"
  type = map(object({
    name                 = string
    instance_type        = string
    image_id             = string
    user_data            = string
    iam_instance_profile = map(string)
    monitoring           = map(bool)
    tag_specifications   = list(any)
    metadata_options     = map(string)
    network_interfaces = list(object({
      associate_public_ip_address = bool
      security_groups             = list(string) # Use `list(string)` for IDs
    }))
  }))
}


module "launch_templates" {
  source = "../../../terraform-aws-modules/launch_template"

  for_each = var.launch_template_configs

  name          = each.value.name
  instance_type = each.value.instance_type
  image_id      = each.value.image_id
  user_data     = base64encode(each.value.user_data)

  network_interfaces = [
    for ni in each.value.network_interfaces : {
      associate_public_ip_address = ni.associate_public_ip_address
      security_groups = [
        for sg in ni.security_groups : module.security_group[sg].id
      ]
    }
  ]

  iam_instance_profile = each.value.iam_instance_profile
  monitoring           = each.value.monitoring
  tag_specifications   = each.value.tag_specifications
  metadata_options     = each.value.metadata_options

  tags = merge(
    local.tags,
    { for ts in each.value.tag_specifications : ts.resource_type => ts.tags }["instance"]
  )
}