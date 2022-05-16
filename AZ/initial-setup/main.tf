terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "main" {}

resource "random_string" "resource_code" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "project_rg" {
  name     = var.project_id
  location = var.location
}

resource "azurerm_storage_account" "tf_storage_account" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.project_rg.name
  location                 = azurerm_resource_group.project_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  depends_on = [azurerm_resource_group.project_rg]
}

resource "azurerm_storage_container" "tf_storage_container" {
  name                  = "state"
  storage_account_name  = azurerm_storage_account.tf_storage_account.name
  container_access_type = "blob"

  depends_on = [azurerm_storage_account.tf_storage_account]
}

resource "azuread_application" "terraform" {
  display_name = "Terraform"
}

resource "azuread_service_principal" "tf_service_principal" {
  application_id = azuread_application.terraform.application_id
  depends_on     = [azuread_application.terraform]
}

resource "azuread_application_password" "tf_application_password" {
  display_name          = "terraformgenerated"
  application_object_id = azuread_application.terraform.object_id

  depends_on = [azuread_application.terraform]
}

resource "azurerm_role_assignment" "main" {
  scope                = data.azurerm_subscription.main.id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.tf_service_principal.id

  depends_on = [azuread_service_principal.tf_service_principal]
}
