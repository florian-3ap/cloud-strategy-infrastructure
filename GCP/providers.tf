provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "default" {
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.kubernetes_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${module.gke.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.kubernetes_cluster.master_auth[0].cluster_ca_certificate)
}
