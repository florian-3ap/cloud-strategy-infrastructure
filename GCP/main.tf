module "gcp_project" {
  source = "./modules/gcp-project"

  project_id = var.project_id
}

module "vpc" {
  source = "./modules/network"

  project_id = var.project_id
  region     = var.region

  depends_on = [module.gcp_project.project_apis]
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"

  project_id       = var.project_id
  region           = var.region
  zone             = var.zone
  vpc_network_name = module.vpc.network_name
  vpc_subnet_name  = module.vpc.subnet_name

  depends_on = [module.vpc.network_name, module.vpc.subnet_name]
}

module "cloud_sql" {
  source = "./modules/cloud-sql"

  project_id = var.project_id
  region     = var.region

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

  show-case-ui-config = {
    base_path = module.vpc.ip_address
  }
  person-management-config = {
    db_jdbc_url = "jdbc:postgresql://localhost:5432/${module.cloud_sql.database_name}"
  }

  cloud_sql_proxy_enabled = true
  cloud_sql_instance_name = module.cloud_sql.cloud_sql_instance_name

  depends_on = [
    module.cloud_sql,
    module.cloud_sql_user,
    module.k8s_cluster.kubernetes_cluster,
    module.k8s_cluster.kubernetes_cluster_primary_nodes
  ]
}

module "k8s_nginx_ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_id

  cloud_provider = "gcp"
  ip_address     = module.vpc.ip_address

  depends_on = [module.k8s_application]
}
