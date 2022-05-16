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
