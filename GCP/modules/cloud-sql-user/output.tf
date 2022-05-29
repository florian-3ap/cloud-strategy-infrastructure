output "username" {
  value = google_sql_user.project_user.name
}

output "password" {
  value = google_sql_user.project_user.password
}
