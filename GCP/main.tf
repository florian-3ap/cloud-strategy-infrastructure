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

  depends_on = [
    module.vpc.network_name,
    module.vpc.subnet_name,
    module.gcp_project.project_apis
  ]
}

module "cloud_sql" {
  source = "./modules/cloud-sql"

  project_id         = var.project_id
  region             = var.region
  zone               = var.zone
  kubernetes_cluster = module.gke.kubernetes_cluster
}

module "nginx-ingress" {
  source = "./modules/k8s-nginx-ingress"

  project_id         = var.project_id
  ip_address         = module.vpc.ip_address
  kubernetes_cluster = module.gke.kubernetes_cluster

  services = [
    {
      name : "show-case-ui",
      port : 80,
      path : "/api",
    },
    {
      name : "person-management-service",
      port : 8080,
      path : "/person-management-service",
    },
  ]
}
