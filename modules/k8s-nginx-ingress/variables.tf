locals {
  validate_ip_address = contains([
    "gcp", "azure"
  ], var.cloud_provider) && length(var.ip_address) > 0
  validate_eip_allocations = "aws" == var.cloud_provider && length(var.eip_allocations) > 0
  validate_subnets         = "aws" == var.cloud_provider && length(var.subnets) > 0
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "cloud_provider" {
  type = string

  validation {
    condition     = contains(["gcp", "azure", "aws"], var.cloud_provider)
    error_message = "Valid values for var: cloud_provider are (gcp, azure, aws)."
  }
}

variable "ip_address" {
  description = "IP Address for exposing Ingress"
  type        = string
  default     = ""
}

variable "eip_allocations" {
  type    = list(string)
  default = []
}

variable "subnets" {
  type    = list(string)
  default = []
}

variable "services" {
  description = "A list of the services that should be routed by ingress."
  type        = list(object({
    name : string
    port : number
    path : string
  }))
  default = [
    {
      name : "person-management-service",
      port : 8080,
      path : "/person-management-service",
    },
    {
      name : "show-case-ui",
      port : 3000,
      path : "/",
    }
  ]
}
