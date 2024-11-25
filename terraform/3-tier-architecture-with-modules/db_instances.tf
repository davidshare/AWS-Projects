variable "db_instances" {
  description = "Map of MySQL DB instance configurations"
  type = map(object({
    identifier                   = string
    instance_class               = string
    engine                       = string
    engine_version               = string
    username_secret              = string
    password_secret              = string
    replicate_source_db          = optional(string)
    allocated_storage            = number
    multi_az                     = bool
    availability_zone            = string
    backup_retention_period      = optional(number)
    db_subnet_group              = string
    manage_master_user_password  = bool
    performance_insights_enabled = bool
    vpc_security_groups          = list(string)
    tags                         = map(string)
  }))
}

module "db_instances" {
  for_each = var.db_instances

  source = "github.com/davidshare/terraform-aws-modules//db_instance?ref=db_instance-v1.0.0"

  identifier                   = each.value.identifier
  instance_class               = each.value.instance_class
  engine                       = each.value.engine
  engine_version               = each.value.engine_version
  username                     = each.value.username_secret != null ? jsondecode(module.secretsmanager_secret_versions[each.value.username_secret].secret_string)["username"] : null
  password                     = each.value.password_secret != null ? jsondecode(module.secretsmanager_secret_versions[each.value.password_secret].secret_string)["password"] : null
  replicate_source_db          = lookup(each.value, "replicate_source_db", null)
  allocated_storage            = each.value.allocated_storage
  multi_az                     = each.value.multi_az
  availability_zone            = each.value.availability_zone
  backup_retention_period      = lookup(each.value, "backup_retention_period", null)
  db_subnet_group_name         = each.value.db_subnet_group != null ? module.db_subnet_groups[each.value.db_subnet_group].name : null
  manage_master_user_password  = each.value.manage_master_user_password
  performance_insights_enabled = each.value.performance_insights_enabled
  vpc_security_group_ids       = [for sg in each.value.vpc_security_groups : module.security_group[sg].id]
  tags                         = merge(each.value.tags, local.tags)
}
