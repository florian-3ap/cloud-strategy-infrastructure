data "azurerm_resource_group" "project_rg" {
  name = var.project_name
}

module "virtual_network" {
  source = "./modules/network"

  project_name        = var.project_name
  location            = data.azurerm_resource_group.project_rg.location
  resource_group_name = data.azurerm_resource_group.project_rg.name
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"

  project_name        = var.project_name
  location            = data.azurerm_resource_group.project_rg.location
  resource_group_name = data.azurerm_resource_group.project_rg.name
  vnet_subnet_id      = module.virtual_network.aks_pods_subnet_id

  depends_on = [module.virtual_network]
}

module "pg_flexible_server" {
  source = "./modules/flexible_server"

  resource_group_name = data.azurerm_resource_group.project_rg.name
  location            = data.azurerm_resource_group.project_rg.location

  database_name       = "person-management"
  delegated_subnet_id = module.virtual_network.pg_subnet_id
  private_dns_zone_id = module.virtual_network.private_dns_zone_id

  depends_on = [module.virtual_network]
}

resource "kubernetes_secret" "db_root_user_secret" {
  metadata {
    name = "postgres-root-db-user"
  }

  data = {
    username = module.pg_flexible_server.administrator_login
    password = module.pg_flexible_server.administrator_password
  }

  depends_on = [module.k8s_cluster]
}


module "k8s-application" {
  source = "../modules/k8s-application"

  show-case-ui-config = {
    base_path = module.k8s_cluster.public_ip
  }
  person-management-config = {
    db_jdbc_url = "jdbc:postgresql://${module.pg_flexible_server.database_fqdn}:5432/${module.pg_flexible_server.database_name}?sslmode=require"
  }

  depends_on = [module.pg_flexible_server, module.k8s_cluster]
}

module "k8s-nginx-ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_name
  ip_address = module.k8s_cluster.public_ip

  depends_on = [module.k8s_cluster]
}
