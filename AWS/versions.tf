terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.12.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }

  required_version = ">= 0.14"
}
