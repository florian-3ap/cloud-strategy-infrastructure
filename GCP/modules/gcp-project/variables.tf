variable "project_id" {
  type = string
}

variable "google_services" {
  type    = set(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "sqladmin.googleapis.com",
  ]
}
