locals {
  username = "psqladmin"
  password = random_password.project_password.result
}

resource "random_password" "project_password" {
  length  = 24
  special = false
}

resource "aws_db_instance" "postgres_db_instance" {
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  engine                 = var.engine_config.name
  engine_version         = var.engine_config.version
  identifier             = var.db_name
  db_name                = var.db_name
  username               = local.username
  password               = local.password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = var.parameter_group_name
  publicly_accessible    = true
  skip_final_snapshot    = true
}
