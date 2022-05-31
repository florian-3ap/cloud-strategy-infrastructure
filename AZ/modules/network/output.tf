output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "aks_pods_subnet_id" {
  value = azurerm_subnet.aks_pods.id
}

output "pg_subnet_id" {
  value = azurerm_subnet.pg_subnet.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.default.id
}
