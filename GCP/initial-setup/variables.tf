variable "project_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west6"
}

variable "zone" {
  type    = string
  default = "europe-west6-a"
}

variable "billing_account" {
  type    = string
  default = "01420F-D7D530-A5E354"
}

variable "org_id" {
  default = "57744860469"
}
