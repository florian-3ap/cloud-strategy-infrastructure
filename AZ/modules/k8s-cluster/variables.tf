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

variable "node_pool_count" {
  description = "Size of the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size of the node"
  type        = string
  default     = "Standard_D2ads_v5"
}
