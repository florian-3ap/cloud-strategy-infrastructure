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

module "k8s-cluster" {
  source = "./modules/k8s-cluster"

  project_name        = var.project_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_subnet_id      = module.virtual_network.aks_pods_subnet_id

  depends_on = [module.virtual_network]
}

module "pg_flexible_server" {
  source = "./modules/flexible_server"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  delegated_subnet_id = module.virtual_network.pg_subnet_id
  private_dns_zone_id = module.virtual_network.private_dns_zone_id

  depends_on = [module.k8s-cluster]
}

module "k8s-application" {
  source = "../modules/k8s-application"

  show-case-ui-config = {
    base_path = module.k8s-cluster.public_ip
  }
  person-management-config = {
    db_jdbc_url = "jdbc:postgresql://${module.pg_flexible_server.database_fqdn}:5432/${module.pg_flexible_server.database_name}?sslmode=require"
  }

  depends_on = [module.pg_flexible_server, module.k8s-cluster]
}

module "k8s-nginx-ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_name
  ip_address = module.k8s-cluster.public_ip

  depends_on = [module.k8s-cluster]
}
