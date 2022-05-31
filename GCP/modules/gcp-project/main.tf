data "google_project" "project" {
  project_id = var.project_id
}

resource "google_project_service" "gcp_services" {
  project  = var.project_id
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com"
  ])
  service = each.key

  depends_on = [data.google_project.project]
}

resource "google_project_service" "project_apis" {
  project  = var.project_id
  for_each = var.google_services
  service  = each.key

  disable_dependent_services = true

  depends_on = [google_project_service.gcp_services]
}
