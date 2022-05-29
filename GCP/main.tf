module "gcp_project" {
  source = "./modules/gcp-project"

  project_id = var.project_id
}

module "network" {
  source = "./modules/network"

  project_id = var.project_id
  region     = var.location.region

  depends_on = [module.gcp_project.project_apis]
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"

  project_id       = var.project_id
  location         = var.location
  vpc_network_name = module.network.network_name
  vpc_subnet_name  = module.network.subnet_name

  depends_on = [module.network.network_name, module.network.subnet_name]
}

module "cloud_sql" {
  source = "./modules/cloud-sql"

  project_id = var.project_id
  region     = var.location.region

  depends_on = [module.gcp_project.project_apis]
}

module "cloud_sql_user" {
  source = "./modules/cloud-sql-user"

  project_id              = var.project_id
  cloud_sql_instance_name = module.cloud_sql.cloud_sql_instance_name

  depends_on = [module.cloud_sql.cloud_sql_instance_name]
}

module "k8s_application" {
  source = "../modules/k8s-application"

  db_username = module.cloud_sql_user.username
  db_password = module.cloud_sql_user.password

  show_case_ui_config = {
    base_path = module.network.ip_address
  }
  person_management_config = {
    db_jdbc_url = "jdbc:postgresql://localhost:5432/${module.cloud_sql.database_name}"
  }

  cloud_sql_proxy_config = {
    enabled       = true
    instance_name = module.cloud_sql.cloud_sql_instance_name
  }

  depends_on = [module.cloud_sql, module.cloud_sql_user, module.k8s_cluster]
}

module "k8s_nginx_ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_id

  cloud_provider = "gcp"
  ip_address     = module.network.ip_address

  depends_on = [module.k8s_application]
}
