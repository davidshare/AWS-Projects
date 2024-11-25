variable "autoscaling_group_attachments" {
  description = "Map of Auto Scaling Group attachments for frontend and backend environments."
  type = map(object({
    autoscaling_group_name = string
    lb_target_group_arn    = string
  }))
  default = {}
}

module "aws_autoscaling_attachments" {
  for_each = var.autoscaling_group_attachments

  source = "github.com/davidshare/terraform-aws-modules//autoscaling_group_attachment?ref=autoscaling_group_attachment-v1.0.0"

  autoscaling_group_name = module.autoscaling_group[each.value.autoscaling_group_name].id
  lb_target_group_arn    = module.lb_target_group[each.value.lb_target_group_arn].arn
  
}
