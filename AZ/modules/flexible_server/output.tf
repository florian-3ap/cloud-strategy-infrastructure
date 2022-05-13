output "database_fqdn" {
  value = azurerm_postgresql_flexible_server.default[0].fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.default[0].name
}

output "administrator_login" {
  value = azurerm_postgresql_flexible_server.default[0].administrator_login
}

output "administrator_password" {
  value = azurerm_postgresql_flexible_server.default[0].administrator_password
}
