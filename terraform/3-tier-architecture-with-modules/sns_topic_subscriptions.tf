variable "sns_topic_subscriptions" {
  description = "Configuration for SNS Topic Subscriptions"
  type = map(object({
    topic_arn     = string
    protocol      = string
    endpoint      = string
    filter_policy = object({ eventType = list(string) })
    delivery_policy = object({
      healthyRetryPolicy = object({
        minDelayTarget     = number
        maxDelayTarget     = number
        numRetries         = number
        numMaxDelayRetries = number
      })
    })
    raw_message_delivery  = bool
    redrive_policy        = object({ deadLetterTargetArn = string })
    subscription_role_arn = string
  }))
}


module "sns_topic_subscription" {
  for_each = var.sns_topic_subscriptions

  source = "github.com/davidshare/terraform-aws-modules//sns_topic_subscription?ref=sns_topic_subscription-v1.0.0"

  topic_arn             = module.sns_topic[each.value.topic_arn].arn
  protocol              = each.value.protocol
  endpoint              = each.value.endpoint
  filter_policy         = jsonencode(each.value.filter_policy)
  delivery_policy       = jsonencode(each.value.delivery_policy)
  raw_message_delivery  = each.value.raw_message_delivery
  subscription_role_arn = each.value.subscription_role_arn
}
