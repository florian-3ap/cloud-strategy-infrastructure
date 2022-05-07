variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "ip_address" {
  description = "IP Address for exposing Ingress"
  type        = string
}

variable "services" {
  description = "A list of the services that should be routed by ingress."
}
