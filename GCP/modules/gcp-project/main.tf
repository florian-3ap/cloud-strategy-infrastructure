resource "google_project" "project" {
  project_id      = var.project_id
  name            = var.project_name
  billing_account = var.billing_account
  skip_delete     = true
}

resource "google_project_service" "gcp_services" {
  project  = google_project.project.project_id
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com"
  ])
  service = each.key
}

resource "google_project_service" "project_apis" {
  project  = google_project.project.project_id
  for_each = var.google_services
  service  = each.key

  disable_dependent_services = true

  depends_on = [google_project_service.gcp_services]
}
