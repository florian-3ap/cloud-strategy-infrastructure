variable "project_id" {
  description = "Name of the project"
  type        = string
}

variable "location" {
  description = "GCP region and zone information"
  type        = object({
    region = string,
    zone   = string
  })
}

variable "vpc_network_name" {
  description = "The name of the VPC network the cluster will connect to"
  type        = string
}

variable "vpc_subnet_name" {
  description = "The name of the VPC subnet the cluster will connect to"
  type        = string
}

variable "gke_num_nodes" {
  description = "The number of GKE nodes."
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "GKE node machine type"
  type        = string
  default     = "n1-standard-1"
}
