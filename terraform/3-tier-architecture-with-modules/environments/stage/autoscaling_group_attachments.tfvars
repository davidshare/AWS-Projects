autoscaling_group_attachments = {
  frontend = {
    autoscaling_group_name = "frontend_asg"
    lb_target_group_arn    = "frontend_tg"
  },
  backend = {
    autoscaling_group_name = "backend_asg"
    lb_target_group_arn    = "backend_tg"
  }
}