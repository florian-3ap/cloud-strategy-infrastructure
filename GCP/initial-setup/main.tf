terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
  }
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
  org_id          = var.org_id
  skip_delete     = false
}

resource "google_service_account" "tf_cicd_service_account" {
  account_id   = "tf-cicd"
  display_name = "CI/CD Service Account"
  project      = google_project.project.project_id

  depends_on = [google_project.project]
}

resource "google_project_iam_member" "tf_cicd_owner" {
  project = google_project.project.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.tf_cicd_service_account.email}"

  depends_on = [google_service_account.tf_cicd_service_account]
}

resource "google_service_account_key" "tf_cicd_key" {
  service_account_id = google_service_account.tf_cicd_service_account.name

  depends_on = [google_project_iam_member.tf_cicd_owner]
}

resource "google_storage_bucket" "terraform-state_bucket" {
  project       = google_project.project.project_id
  name          = "${var.project_name}-terraform-state"
  location      = var.region
  force_destroy = true

  depends_on = [google_project.project]
}
