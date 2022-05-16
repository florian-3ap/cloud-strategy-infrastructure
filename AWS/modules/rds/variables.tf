variable "db_subnet_group_name" {
  description = "The subnet group name for the rds instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group ids"
  type        = list(string)
}
