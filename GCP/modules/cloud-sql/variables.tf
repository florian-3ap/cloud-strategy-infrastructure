variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "database_version" {
  description = "Database Version"
  default     = "POSTGRES_13"
}

variable "postgres_machine_type" {
  description = "Postgres Machine Type"
  default     = "db-f1-micro"
}
