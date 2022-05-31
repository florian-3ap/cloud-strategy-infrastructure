data "azurerm_resource_group" "rg" {
  name = var.project_id
}

module "network" {
  source = "./modules/network"

  project_id     = var.project_id
  resource_group = data.azurerm_resource_group.rg
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"

  project_id     = var.project_id
  resource_group = data.azurerm_resource_group.rg
  vnet_subnet_id = module.network.aks_pods_subnet_id

  depends_on = [module.network]
}

module "pg_flexible_server" {
  source = "./modules/flexible_server"

  database_name       = "person-management"
  resource_group      = data.azurerm_resource_group.rg
  delegated_subnet_id = module.network.pg_subnet_id
  private_dns_zone_id = module.network.private_dns_zone_id

  depends_on = [module.network]
}

module "k8s_application" {
  source = "../modules/k8s-application"

  db_username = module.pg_flexible_server.administrator_login
  db_password = module.pg_flexible_server.administrator_password

  show_case_ui_config = {
    base_path = module.k8s_cluster.public_ip
  }
  person_management_config = {
    db_jdbc_url = "jdbc:postgresql://${module.pg_flexible_server.database_fqdn}:5432/${module.pg_flexible_server.database_name}?sslmode=require"
  }

  depends_on = [module.pg_flexible_server, module.k8s_cluster]
}

module "k8s_nginx_ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id     = var.project_id
  cloud_provider = "azure"
  ip_address     = module.k8s_cluster.public_ip

  depends_on = [module.k8s_application]
}
