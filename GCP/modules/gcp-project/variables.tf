variable "project_id" {
  description = "The ID of the Project"
  type        = string
}

variable "google_services" {
  description = "List of google services to enable"
  type        = set(string)
  default     = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}
