output "rds_address" {
  value = aws_db_instance.postgres_db_instance.address
}

output "port" {
  value = aws_db_instance.postgres_db_instance.port
}

output "db_name" {
  value = aws_db_instance.postgres_db_instance.db_name
}
