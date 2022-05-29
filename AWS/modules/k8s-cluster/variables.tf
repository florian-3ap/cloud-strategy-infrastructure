variable "project_id" {
  description = "The ID of the Project"
  type        = string
}

variable "cluster_version" {
  description = "Version of the kubernetes cluster"
  type        = string
  default     = "1.22"
}

variable "vpc_id" {
  description = "VPC id where the cluster and workers will be deployed."
  type        = string
}

variable "subnets" {
  description = "A list of subnets to place the EKS cluster and workers within."
}

variable "worker_group_instance_Type" {
  description = "Type of the instance from the worker group"
  type        = string
  default     = "t2.small"
}

variable "worker_group_count" {
  description = "Size of the default worker group"
  type        = number
  default     = 2
}
