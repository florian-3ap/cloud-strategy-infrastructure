terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-strategy-poc"
    storage_account_name = "tfstate3qwuyj"
    container_name       = "state"
    key                  = "terraform.tfstate"
  }
}
