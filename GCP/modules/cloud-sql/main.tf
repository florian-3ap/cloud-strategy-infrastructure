resource "random_id" "random_postgres_name_suffix" {
  byte_length = 3
}

resource "google_sql_database_instance" "master" {
  project             = var.project_id
  name                = "${var.project_id}-postgres-${random_id.random_postgres_name_suffix.dec}"
  database_version    = var.postgres_version
  region              = var.region
  deletion_protection = false

  settings {
    tier              = var.postgres_machine_type
    availability_type = "ZONAL"

    backup_configuration {
      enabled = false
    }
  }
}

resource "google_sql_database" "database" {
  project  = var.project_id
  name     = var.project_id
  instance = google_sql_database_instance.master.name
}

resource "random_password" "project_password" {
  length  = 24
  special = true
}

resource "google_sql_user" "project_user" {
  project  = var.project_id
  instance = google_sql_database_instance.master.name
  name     = "${var.project_id}-db"
  password = random_password.project_password.result
}

resource "kubernetes_secret" "db_root_user_secret" {
  metadata {
    name = "postgres-root-db-user"
  }

  data = {
    username = google_sql_user.project_user.name
    password = google_sql_user.project_user.password
  }

  depends_on = [var.kubernetes_cluster]
}
