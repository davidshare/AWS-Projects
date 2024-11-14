variable "elastic_ips" {
  description = "Map of Elastic IP configurations"
  type = map(object({
    domain = string
    tags   = map(string)
  }))
}

/* Elastic IP for NAT */
module "elastic_ip" {
  for_each = var.elastic_ips

  source = "../../../terraform-aws-modules/elastic_ip"

  domain = each.value.domain
  tags   = merge(each.value.tags, local.tags)

  depends_on = [module.internet_gateway]
}