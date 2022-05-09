output "cloud_sql_instance_name" {
  value = google_sql_database_instance.master.name
}

output "database_name" {
  value = google_sql_database.database.name
}
