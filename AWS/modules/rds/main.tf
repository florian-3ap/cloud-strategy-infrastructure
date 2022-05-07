resource "aws_db_instance" "postgres_db_instance" {
  allocated_storage      = 10
  instance_class         = "db.t3.micro"
  engine                 = "postgres"
  engine_version         = "13.6"
  identifier             = "personmanagement"
  db_name                = "personmanagement"
  username               = "acme"
  password               = "12345678"
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = "default.postgres13"
  publicly_accessible    = true
  skip_final_snapshot    = true

  depends_on = [var.db_subnet_group_name, var.vpc_security_group_ids]
}
