provider "google" {
  project = var.project_id
  region  = var.location.region
  zone    = var.location.zone
}

data "google_client_config" "default" {
  depends_on = [module.gcp_project]
}

provider "kubernetes" {
  host                   = "https://${module.k8s_cluster.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.k8s_cluster.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.k8s_cluster.kubernetes_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.k8s_cluster.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = "https://${module.k8s_cluster.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.k8s_cluster.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
}
