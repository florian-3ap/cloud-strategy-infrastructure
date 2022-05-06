output "cloud_sql_instance" {
  value = google_sql_database_instance.master.name
}
