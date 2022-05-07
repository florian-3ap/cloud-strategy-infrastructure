variable "db_subnet_group_name" {
  description = "Subnet group name"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Subnet group name"
  type        = list(string)
}
