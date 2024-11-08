    bucket         = "terraform-state-stage"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dynamodb-lock-table-stage"
    encrypt        = true