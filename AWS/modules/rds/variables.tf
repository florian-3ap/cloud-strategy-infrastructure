variable "db_subnet_group_name" {
  description = "The subnet group name for the rds instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group ids"
  type        = list(string)
}

variable "allocated_storage" {
  description = "Storage amount for the database"
  type        = number
  default     = 10
}

variable "engine_config" {
  description = "Configuration of the database engine"
  type        = object({
    name    = string
    version = string
  })
  default = {
    name    = "postgres"
    version = "13.6"
  }
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = "default.postgres13"
}
