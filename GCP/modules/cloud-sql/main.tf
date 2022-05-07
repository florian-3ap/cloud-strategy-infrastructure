resource "random_id" "random_postgres_name_suffix" {
  byte_length = 3
}

resource "google_sql_database_instance" "master" {
  project             = var.project_id
  name                = "${var.project_id}-postgres-${random_id.random_postgres_name_suffix.dec}"
  database_version    = var.database_version
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
