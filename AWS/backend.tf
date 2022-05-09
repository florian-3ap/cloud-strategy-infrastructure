terraform {
  backend "s3" {
    bucket = "cloud-strategy-poc-terraform-state"
    key    = "states/terraform.tfstate"
    region = "eu-central-1"
  }
}
