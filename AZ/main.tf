resource "azurerm_resource_group" "rg" {
  name     = var.project_name
  location = var.location
}

module "virtual_network" {
  source = "./modules/virtual_network"

  project_name        = var.project_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  dns_prefix          = "${var.project_name}-k8s"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2ads_v5"
    vnet_subnet_id = module.virtual_network.aks_pods_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [module.virtual_network]
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

module "pg_flexible_server" {
  source = "./modules/flexible_server"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  delegated_subnet_id = module.virtual_network.pg_subnet_id
  private_dns_zone_id = module.virtual_network.private_dns_zone_id

  depends_on = [module.virtual_network, azurerm_kubernetes_cluster.aks]
}

module "k8s-application" {
  source = "../modules/k8s-application"

  show-case-ui-config = {
    base_path = azurerm_public_ip.nginx_ingress.ip_address
  }
  person-management-config = {
    db_jdbc_url = "jdbc:postgresql://${module.pg_flexible_server.database_fqdn}:5432/${module.pg_flexible_server.database_name}?sslmode=require"
  }

  depends_on = [module.pg_flexible_server, azurerm_public_ip.nginx_ingress]
}

module "k8s-nginx-ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_name
  ip_address = azurerm_public_ip.nginx_ingress.ip_address

  depends_on = [azurerm_kubernetes_cluster.aks, azurerm_public_ip.nginx_ingress]
}
