variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "project_name" {
  description = "Project Display Name"
  type        = string
}

variable "billing_account" {
  description = "Google Cloud Billing Account"
  type        = string
}

variable "google_services" {
  description = "Google Services to Enable"
  type        = set(string)
  default     = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}
