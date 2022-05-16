variable "project_name" {
  description = "The name of the Project"
  type        = string
}

variable "project_id" {
  description = "The ID of the Project"
  type        = string
}

variable "region" {
  description = "GCP Region information"
  type        = string
  default     = "europe-west6"
}

variable "zone" {
  description = "GCP Zone information"
  type        = string
  default     = "europe-west6-a"
}

variable "billing_account" {
  description = "Billing account for the GCP project"
  type        = string
  default     = "01420F-D7D530-A5E354"
}

variable "org_id" {
  description = "Id od the organization"
  type        = string
  default     = "57744860469"
}
