terraform {
  backend "azurerm" {
    resource_group_name  = "cloud-strategy-poc"
    storage_account_name = "tfstatebex9hk"
    container_name       = "state"
    key                  = "terraform.tfstate"
  }
}
