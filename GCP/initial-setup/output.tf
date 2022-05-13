output "project_id" {
  value = google_project.project.project_id
}

output "project_name" {
  value = google_project.project.name
}

output "bucket_name" {
  value = google_storage_bucket.terraform-state_bucket.name
}
