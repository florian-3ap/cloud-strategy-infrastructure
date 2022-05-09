terraform {
  backend "s3" {
    bucket = "cloud-strategy-poc-terraform-state"
    key    = "state/default.tfstate"
    region = "eu-central-1"
  }
}
