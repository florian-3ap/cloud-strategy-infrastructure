output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ip_address" {
  value = aws_eip.nat.public_ip
}

output "ip_address_id" {
  value = aws_eip.nat.id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.name
}
