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

resource "azurerm_postgresql_flexible_server" "person-management-server" {
  name                   = "person-management-server"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "13"
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = local.username
  administrator_password = local.password
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2s_v3"
  zone                   = "1"
}

resource "azurerm_postgresql_flexible_server_database" "person-management" {
  name      = "person-management"
  server_id = azurerm_postgresql_flexible_server.person-management-server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  depends_on = [azurerm_postgresql_flexible_server.person-management-server]
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
