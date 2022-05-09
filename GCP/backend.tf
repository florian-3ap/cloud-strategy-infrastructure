terraform {
  backend "gcs" {
    bucket = "cloud-strategy-poc-terraform-state"
    prefix = "state"
  }
}
