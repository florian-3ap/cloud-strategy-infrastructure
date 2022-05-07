terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }

  required_version = ">= 0.14"
}
