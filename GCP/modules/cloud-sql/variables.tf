variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "zone" {
  description = "Zone"
  type        = string
}

variable "postgres_version" {
  description = "Postgres Version"
  default     = "POSTGRES_13"
}

variable "postgres_machine_type" {
  description = "Postgres Machine Type"
  default     = "db-f1-micro"
}

variable "kubernetes_cluster" {
  description = "K8s Cluster"
}
