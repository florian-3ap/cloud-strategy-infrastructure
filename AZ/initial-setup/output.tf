output "resource_group" {
  value = azurerm_resource_group.project_rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tf_storage_account.name
}

output "tenant_id" {
  value = azuread_service_principal.tf_service_principal.application_tenant_id
}

output "client_id" {
  value = azuread_service_principal.tf_service_principal.application_id
}

output "client_secret" {
  value = nonsensitive(azuread_service_principal_password.tf_service_principal_password.value)
}
