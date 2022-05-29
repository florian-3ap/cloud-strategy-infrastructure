resource "random_password" "project_password" {
  length  = 24
  special = true
}

resource "google_sql_user" "project_user" {
  project  = var.project_id
  instance = var.cloud_sql_instance_name
  name     = "${var.project_id}-db"
  password = random_password.project_password.result
}
