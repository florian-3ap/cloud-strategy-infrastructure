output "kubernetes_cluster" {
  value = google_container_cluster.primary
}

output "kubernetes_cluster_primary_nodes" {
  value       = google_container_node_pool.primary_nodes
  description = "GKE cluster primary nodes"
}
