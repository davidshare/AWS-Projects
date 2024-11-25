variable "sns_topics" {
  description = "Configuration for SNS Topics"
  type = map(object({
    name                        = string
    display_name                = string
    kms_master_key_id           = string
    fifo_topic                  = bool
    content_based_deduplication = bool
    tags                        = map(string)
  }))
}

module "sns_topic" {
  for_each = var.sns_topics

  source = "github.com/davidshare/terraform-aws-modules//sns_topic?ref=sns_topic-v1.0.0"

  name                        = each.value.name
  display_name                = each.value.display_name
  kms_master_key_id           = each.value.kms_master_key_id
  fifo_topic                  = each.value.fifo_topic
  content_based_deduplication = each.value.content_based_deduplication
  tags                        = each.value.tags
}
