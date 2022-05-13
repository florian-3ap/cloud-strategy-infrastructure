output "resource_group" {
  value = azurerm_resource_group.project_rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tf_storage_account.name
}
