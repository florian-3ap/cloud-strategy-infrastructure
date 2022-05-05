module "gcp-project" {
  source = "./modules/gcp-project"

  project_id      = var.project_id
  project_name    = var.project_name
  billing_account = var.billing_account
}

module "network" {
  source = "./modules/networking"

  project_id = var.project_id
  region     = var.region

  depends_on = [module.gcp-project.project_apis]
}

module "gke" {
  source = "./modules/gke"

  project_id       = var.project_id
  project_name     = var.project_name
  region           = var.region
  zone             = var.zone
  vpc_network_name = module.network.network_name
  vpc_subnet_name  = module.network.subnet_name

  depends_on = [module.gcp-project.project_apis]
}

module "cloud_sql" {
  source = "./modules/cloud-sql"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  depends_on = [
    module.gcp-project.project_apis,
    module.gke.kubernetes_cluster,
    module.gke.kubernetes_cluster_primary_nodes
  ]
}
