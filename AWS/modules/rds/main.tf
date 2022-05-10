terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }
  required_version = ">= 0.14"
}

locals {
  username = "psqladmin"
  password = random_password.project_password.result
}

resource "random_password" "project_password" {
  length  = 24
  special = false
}

resource "aws_db_instance" "postgres_db_instance" {
  allocated_storage      = 10
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  engine_version         = "13.6"
  identifier             = "personmanagement"
  db_name                = "personmanagement"
  username               = local.username
  password               = local.password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = "default.postgres13"
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "kubernetes_secret" "db_root_user_secret" {
  metadata {
    name = "postgres-root-db-user"
  }

  data = {
    username = local.username
    password = local.password
  }
}

