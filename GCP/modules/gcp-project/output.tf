output "project_id" {
  value       = var.project_id
  description = "Google Project ID"
}

output "project_apis" {
  description = "Enabled Project APIs"
  value       = google_project_service.project_apis
}
