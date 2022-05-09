variable "show-case-ui-config" {
  type = object({
    base_path : string
  })
}

variable "person-management-config" {
  type = object({
    db_jdbc_url : string
  })
}

variable "cloud_sql_proxy_enabled" {
  type    = bool
  default = false
}

variable "cloud_sql_instance_name" {
  description = "Name of cloud sql instance"
  type        = string
  default     = ""
}
