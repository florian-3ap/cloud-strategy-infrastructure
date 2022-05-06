data "google_client_config" "default" {
}

provider "kubernetes" {
  host                   = "https://${var.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    var.kubernetes_cluster.master_auth[0].cluster_ca_certificate,
  )
}
