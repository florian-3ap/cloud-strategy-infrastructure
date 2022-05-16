resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = "${var.project_id}-gke"
  location = var.location.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_network_name
  subnetwork = var.vpc_subnet_name

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  project    = var.project_id
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.location.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = var.machine_type
    tags         = ["gke-node", google_container_cluster.primary.name]
    metadata     = {
      disable-legacy-endpoints = "true"
    }
  }
}
