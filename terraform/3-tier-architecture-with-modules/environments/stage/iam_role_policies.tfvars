role_policies = {
  "web" = {
    name = "web-policy"
    role = "web-instances-role"
    policy = {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["s3:GetObject", "s3:ListBucket"]
          Resource = ["arn:aws:s3:::web-assets/*", "arn:aws:s3:::web-assets"]
        },
        {
          Effect   = "Allow"
          Action   = ["apigateway:GET", "apigateway:POST"]
          Resource = ["arn:aws:apigateway:us-east-1::/restapis/*"]
        }
      ]
    }
  },

  "backend" = {
    name = "backend-policy"
    role = "backend-instances-role"
    policy = {
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["ec2:DescribeInstances", "ec2:StartInstances", "ec2:StopInstances"]
          Resource = ["arn:aws:ec2:us-east-1:*:instance/*"]
        },
        {
          Effect   = "Allow"
          Action   = ["rds:DescribeDBInstances", "rds:Connect"]
          Resource = ["arn:aws:rds:us-east-1:*:db:mysql-db-instance"]
        },
        {
          Effect   = "Allow"
          Action   = ["dynamodb:Query", "dynamodb:Scan", "dynamodb:PutItem"]
          Resource = ["arn:aws:dynamodb:us-east-1:*:table/my-table"]
        }
      ]
    }
  }
}
