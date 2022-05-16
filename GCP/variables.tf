variable "project_id" {
  description = "Name of the project"
  type        = string
}

variable "location" {
  description = "GCP region and zone information"
  type        = object({
    region = string,
    zone   = string
  })
  default = {
    region = "europe-west6",
    zone   = "europe-west6-a"
  }
}
