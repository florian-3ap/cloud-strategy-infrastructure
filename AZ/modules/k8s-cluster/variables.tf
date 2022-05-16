variable "project_id" {
  description = "The ID of the Project"
  type        = string
}

variable "resource_group" {
  description = "Resource group of the project"
}

variable "vnet_subnet_id" {
  description = "The id of the VNET subnet which the cluster connects to"
  type        = string
}
