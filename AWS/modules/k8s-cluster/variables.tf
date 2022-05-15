variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.22"
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  description = "VPC subnets"
}
