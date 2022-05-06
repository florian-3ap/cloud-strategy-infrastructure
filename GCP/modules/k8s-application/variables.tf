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

variable "cloud_sql_instance_name" {
  description = "Name of cloud sql instance"
}
