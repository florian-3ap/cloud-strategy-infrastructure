resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  dns_prefix          = "${var.project_name}-k8s"
  location            = var.location
  resource_group_name = var.resource_group_name

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2ads_v5"
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_public_ip" "nginx_ingress" {
  name                = "nginx_ingress_public_ip"
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.project_name
  location            = azurerm_kubernetes_cluster.aks.location
  resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group

  depends_on = [azurerm_kubernetes_cluster.aks]
}
