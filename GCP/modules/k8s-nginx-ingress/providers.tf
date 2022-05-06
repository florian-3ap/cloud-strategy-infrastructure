terraform {
  required_version = ">= 0.12"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

data "google_client_config" "default" {
}

provider "helm" {
  kubernetes {
    host                   = "https://${var.kubernetes_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      var.kubernetes_cluster.master_auth[0].cluster_ca_certificate,
    )
  }
}

provider "kubernetes" {
  host                   = "https://${var.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    var.kubernetes_cluster.master_auth[0].cluster_ca_certificate,
  )
}
