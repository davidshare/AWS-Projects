sns_topics = {
  frontend_topic = {
    name                        = "frontend-topic"
    display_name                = "Frontend Notifications"
    kms_master_key_id           = null
    fifo_topic                  = false
    content_based_deduplication = false
    tags = {
      Tier = "frontend"
    }
  }

  backend_topic = {
    name                        = "backend-topic"
    display_name                = "Backend Notifications"
    kms_master_key_id           = null
    fifo_topic                  = false
    content_based_deduplication = false
    tags = {
      Tier = "backend"
    }
  }
}
