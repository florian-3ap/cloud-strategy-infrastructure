resource "random_id" "random_suffix" {
  byte_length = 3
}

resource "google_sql_database_instance" "master" {
  project             = var.project_id
  name                = "${var.project_id}-postgres-${random_id.random_suffix.dec}"
  database_version    = var.database_version
  region              = var.region
  deletion_protection = false

  settings {
    tier              = var.postgres_machine_type
    availability_type = var.availability_type

    maintenance_window {
      day  = 6
      hour = 23
    }

    backup_configuration {
      enabled    = var.backup_enabled
      start_time = var.backup_start_time
      location   = var.region
    }
  }
}

resource "google_sql_database" "database" {
  project  = var.project_id
  name     = var.project_id
  instance = google_sql_database_instance.master.name
}
