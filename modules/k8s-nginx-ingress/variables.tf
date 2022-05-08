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
