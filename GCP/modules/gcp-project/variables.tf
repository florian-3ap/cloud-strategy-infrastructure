variable "project_id" {
  description = "Project ID"
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
