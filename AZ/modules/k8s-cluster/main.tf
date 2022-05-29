resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_id}-aks"
  dns_prefix          = "${var.project_id}-k8s"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  default_node_pool {
    name           = "default"
    node_count     = var.node_pool_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}
