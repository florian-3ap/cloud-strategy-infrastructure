variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "zone" {
  description = "Zone"
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the VPC network the cluster will connect to."
}

variable "vpc_subnet_name" {
  description = "The name of the VPC subnet the cluster will connect to."
}

variable "gke_num_nodes" {
  default     = 1
  description = "Number of gke nodes"
}

variable "machine_type" {
  description = "GKE machine type"
  default     = "n1-standard-1"
}
