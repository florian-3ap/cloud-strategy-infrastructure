variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "vpc_network_name" {
  type = string
}

variable "vpc_subnet_name" {
  type = string
}

variable "gke_num_nodes" {
  type    = number
  default = 2
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}
