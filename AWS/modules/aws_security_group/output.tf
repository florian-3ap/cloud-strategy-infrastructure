output "worker_group_mgmt_id" {
  value = aws_security_group.worker_group_mgmt.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
