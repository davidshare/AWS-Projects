variable "database_subnet_groups" {}
variable "db_instances" {}
variable "replica_db_instances" {}
variable "db_instances_secrets" {}

resource "aws_db_subnet_group" "db_subnet_groups" {
  for_each = var.database_subnet_groups

  name        = each.value.name
  subnet_ids  = [for subnet in each.value.subnets : local.subnet_ids_map[subnet]]
  description = each.value.description

  tags = merge(each.value.tags, local.tags)

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_db_instance" "db_instances" {
  for_each = var.db_instances

  identifier              = "${var.project}-${each.value.identifier}"
  allocated_storage       = each.value.allocated_storage
  engine                  = each.value.engine
  engine_version          = each.value.engine_version
  instance_class          = each.value.instance_class
  db_name                 = var.db_instances_secrets[each.key].db_name
  username                = var.db_instances_secrets[each.key].username
  password                = var.db_instances_secrets[each.key].password
  backup_retention_period = each.value.backup_retention_period
  skip_final_snapshot     = each.value.skip_final_snapshot
  availability_zone       = each.value.availability_zone
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_groups[each.value.db_subnet_group].name
  multi_az                = each.value.multi_az
  vpc_security_group_ids  = [for sg in each.value.vpc_sgs : aws_security_group.security_groups[sg].id]
  tags                    = merge(each.value.tags, local.tags)

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_db_instance" "replica_db_instances" {
  for_each            = var.replica_db_instances
  
  identifier          = "${var.project}-${each.value.identifier}"
  instance_class      = each.value.instance_class
  skip_final_snapshot = each.value.skip_final_snapshot
  replicate_source_db = aws_db_instance.db_instances[each.value.replicate_source_db].identifier
}