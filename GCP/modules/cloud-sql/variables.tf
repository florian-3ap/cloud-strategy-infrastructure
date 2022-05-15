variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "database_version" {
  type    = string
  default = "POSTGRES_13"
}

variable "postgres_machine_type" {
  type    = string
  default = "db-f1-micro"
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "backup_enabled" {
  type    = bool
  default = false
}

variable "backup_start_time" {
  type    = string
  default = "01:00"
}
