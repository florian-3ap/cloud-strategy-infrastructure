variable "project_id" {
  description = "Name of the project"
  type        = string
}

variable "region" {
  description = "The region the GCP resources should be created in"
  type        = string
}

variable "database_version" {
  description = "Database version"
  type        = string
  default     = "POSTGRES_13"
}

variable "postgres_machine_type" {
  description = "Database machine type"
  type        = string
  default     = "db-f1-micro"
}

variable "availability_type" {
  description = "Availability type of the database instance"
  type        = string
  default     = "ZONAL"
}

variable "backup_enabled" {
  description = "Database backup enabled"
  type        = bool
  default     = false
}

variable "backup_start_time" {
  description = "Start time of the database backup"
  type        = string
  default     = "01:00"
}
