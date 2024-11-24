sns_topic_subscriptions = {
  frontend_subscription = {
    topic_arn = "frontend_topic"
    protocol  = "email"
    endpoint  = "davidessienshare@gmail.com"
    filter_policy = {
      eventType = ["create", "update"]
    }
    delivery_policy = {
      healthyRetryPolicy = {
        minDelayTarget     = 1,
        maxDelayTarget     = 60,
        numRetries         = 5,
        numMaxDelayRetries = 2
      }
    }
    raw_message_delivery  = false
    redrive_policy        = null
    subscription_role_arn = null
  }

  backend_subscription = {
    topic_arn = "backend_topic"
    protocol  = "email"
    endpoint  = "davidessienshare@gmail.com"
    filter_policy = {
      eventType = ["delete"]
    }
    delivery_policy = {
      healthyRetryPolicy = {
        minDelayTarget     = 5,
        maxDelayTarget     = 120,
        numRetries         = 3,
        numMaxDelayRetries = 1
      }
    }
    raw_message_delivery  = false
    redrive_policy        = null
    subscription_role_arn = null
  }
}
