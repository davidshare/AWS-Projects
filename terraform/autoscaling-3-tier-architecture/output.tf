output "tersu_primary_db_endpoint" {
  value       = aws_db_instance.db_instances["db_primary"].endpoint
  description = "The endpoint of the RDS tersu primary_db instance"
}

output "load_balancers" {
  value = {
    frontend = {
      name     = aws_lb.loadbalancers["frontend"].name
      dns_name = aws_lb.loadbalancers["frontend"].dns_name
      arn      = aws_lb.loadbalancers["frontend"].arn
      id       = aws_lb.loadbalancers["frontend"].id
    }
    backend = {
      name     = aws_lb.loadbalancers["backend"].name
      dns_name = aws_lb.loadbalancers["backend"].dns_name
      arn      = aws_lb.loadbalancers["backend"].arn
      id       = aws_lb.loadbalancers["backend"].id
    }
  }
  description = "Information about the frontend and backend load balancers"
}