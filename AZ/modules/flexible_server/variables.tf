variable "resource_group" {
  description = "Resource group of the project"
}

variable "database_name" {
  description = "Name of the database instance"
  type        = string
}

variable "type" {
  description = "Type of the flexible server"
  type        = object({
    name = string
    version : string
  })
  default = {
    name    = "postgresql"
    version = "13"
  }
}

variable "delegated_subnet_id" {
  description = "The id of the VPC subnet which the cluster connects to"
  type        = string
}

variable "private_dns_zone_id" {
  description = "Private DNS zone id of the flexible server"
  type        = string
}

variable "storage_mb" {
  description = "Size of the database storage in MB"
  type        = number
  default     = 32768
}

variable "machine_type" {
  description = "Machine type of the database instance"
  type        = string
  default     = "GP_Standard_D2s_v3"
}

variable "zone" {
  type    = string
  default = "1"
}
