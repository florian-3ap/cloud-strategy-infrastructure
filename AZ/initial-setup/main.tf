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

resource "random_string" "resource_code" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "project_rg" {
  name     = var.project_name
  location = var.location
}

resource "azurerm_storage_account" "tf_storage_account" {
  name                     = "tfstate${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.project_rg.name
  location                 = azurerm_resource_group.project_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tf_storage_container" {
  name                  = "state"
  storage_account_name  = azurerm_storage_account.tf_storage_account.name
  container_access_type = "blob"
}

resource "azuread_application" "terraform" {
  display_name = "Terraform"
}

resource "azuread_service_principal" "tf_service_principal" {
  application_id = azuread_application.terraform.application_id
}

resource "azuread_service_principal_password" "tf_service_principal_password" {
  service_principal_id = azuread_service_principal.tf_service_principal.object_id
}
