variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "database_name" {
  type = string
}

variable "type" {
  type = object({
    name = string
    version : string
  })
  default = {
    name    = "postgresql"
    version = "13"
  }
}

variable "delegated_subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "machine_type" {
  type    = string
  default = "GP_Standard_D2s_v3"
}

variable "zone" {
  type    = string
  default = "1"
}
