output "vpc_id" {
  value = module.vpc.vpc_id
}

output "aws_eip_ids" {
  value = aws_eip.nat.*.id
}

output "public_ips" {
  value = aws_eip.nat.*.public_ip
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
