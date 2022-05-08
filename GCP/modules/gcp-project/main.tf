resource "google_project_service" "project_apis" {
  project  = var.project_id
  for_each = var.google_services
  service  = each.key

  disable_dependent_services = true
}
