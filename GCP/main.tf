module "gcp_project" {
  source = "./modules/gcp-project"

  project_id = var.project_id
}

module "vpc" {
  source = "./modules/vpc"

  project_id = var.project_id
  region     = var.region

  depends_on = [module.gcp_project.project_apis]
}

module "gke" {
  source = "./modules/gke"

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
  zone       = var.zone

  depends_on = [module.gcp_project.project_apis]
}

module "cloud_sql_user" {
  source = "./modules/cloud-sql-user"

  project_id              = var.project_id
  cloud_sql_instance_name = module.cloud_sql.cloud_sql_instance_name

  depends_on = [module.cloud_sql.cloud_sql_instance_name]
}

module "nginx-ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_id
  ip_address = module.vpc.ip_address

  depends_on = [
    module.vpc.ip_address,
    module.gke.kubernetes_cluster,
    module.gke.kubernetes_cluster_primary_nodes
  ]
}

module "k8s-application" {
  source = "../modules/k8s-application"

  ip_address              = module.vpc.ip_address
  cloud_sql_instance_name = module.cloud_sql.cloud_sql_instance_name

  depends_on = [
    module.vpc.ip_address,
    module.gke.kubernetes_cluster,
    module.gke.kubernetes_cluster_primary_nodes,
    module.cloud_sql.cloud_sql_instance_name,
    module.cloud_sql_user
  ]
}
