output "database_fqdn" {
  value = azurerm_postgresql_flexible_server.person-management-server.fqdn
}

output "database_name" {
  value = azurerm_postgresql_flexible_server_database.person-management.name
}
