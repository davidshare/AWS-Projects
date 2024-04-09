variable "launch_templates" {}
variable "autoscaling_groups" {}
variable "autoscaling_attachments" {}


resource "aws_launch_template" "launch_templates" {
  for_each = var.launch_templates

  name          = "${var.project}-${each.value.name}"
  image_id      = each.value.image_id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  user_data     = filebase64("${each.value.user_data}")

  network_interfaces {
    subnet_id       = local.subnet_ids_map[each.value.network_interfaces.subnet_id]
    security_groups = [for sg in each.value.network_interfaces.security_groups : aws_security_group.frontend_security_group[sg].id]
  }

  tag_specifications {
    resource_type = each.value.tag_specifications.resource_type
    tags          = merge(each.value.tag_specifications.tags, local.tags)
  }

  lifecycle {
    ignore_changes = [tag_specifications]
  }
}

resource "aws_autoscaling_group" "autoscaling_groups" {
  for_each = var.autoscaling_groups

  name                      = "${var.project}-${each.value.name}"
  desired_capacity          = each.value.desired_capacity
  min_size                  = each.value.min_size
  max_size                  = each.value.max_size
  health_check_grace_period = each.value.health_check_grace_period
  force_delete              = each.value.force_delete
  health_check_type         = each.value.health_check_type
  vpc_zone_identifier       = [for subnet in each.value.subnets : local.subnet_ids_map[subnet]]
  enabled_metrics           = each.value.enabled_metrics
  metrics_granularity       = each.value.metrics_granularity

  launch_template {
    id = aws_launch_template.launch_templates[each.value.launch_template].id
  }

  depends_on = [aws_launch_template.launch_templates]
}

resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  for_each = var.autoscaling_attachments

  autoscaling_group_name = aws_autoscaling_group.autoscaling_groups[each.value.autoscaling_group].id
  lb_target_group_arn                    = aws_lb_target_group.lb_target_groups[each.value.lb_target_group].arn
}