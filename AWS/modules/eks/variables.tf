variable "cluster_name" {
  description = "Name of EKS Cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of EKS Cluster"
  type        = string
  default     = "1.22"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "VPC subnets"
}

variable "worker_group_mgmt_id" {
  description = "Worker group mgmt id"
}
