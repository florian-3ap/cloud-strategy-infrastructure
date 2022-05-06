variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "kubernetes_cluster" {
  description = "K8s Cluster"
}

variable "kubernetes_cluster_primary_nodes" {
  description = "K8s Cluster Primary Nodes"
}

variable "ip_address" {
  description = "IP Address for exposing Ingress"
  type        = string
}

variable "services" {
  description = "A list of the services that should be routed by ingress."
}
