variable "show_case_ui_config" {
  description = "Configuration of the show-case-ui service"
  type        = object({
    base_path : string
  })
}

variable "person_management_config" {
  description = "Configuration of the person-management service"
  type        = object({
    db_jdbc_url : string
  })
}

variable "cloud_sql_proxy_config" {
  description = "Configuration of the GCP cloud sql proxy"
  type        = object({
    enabled : bool
    instance_name : string
  })
  default = {
    enabled       = false
    instance_name = ""
  }
}
