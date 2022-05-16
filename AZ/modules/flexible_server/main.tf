locals {
  username = "psqladmin"
  password = random_password.project_password.result
}

resource "random_password" "project_password" {
  length  = 24
  special = false
}

resource "azurerm_postgresql_flexible_server" "default" {
  count                  = var.type.name == "postgresql" ? 1 : 0
  name                   = "${var.database_name}-server"
  resource_group_name    = var.resource_group.name
  location               = var.resource_group.location
  version                = var.type.version
  delegated_subnet_id    = var.delegated_subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = local.username
  administrator_password = local.password
  storage_mb             = var.storage_mb
  sku_name               = var.machine_type
  zone                   = var.zone
}

resource "azurerm_postgresql_flexible_server_database" "default" {
  count     = var.type.name == "postgresql" ? 1 : 0
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.default[0].id
  collation = "en_US.utf8"
  charset   = "UTF8"

  depends_on = [azurerm_postgresql_flexible_server.default[0]]
}
