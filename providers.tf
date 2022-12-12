terraform {
  required_version = "~> 1.3.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }
  backend "gcs" {}
}

provider "google" {
  project = var.gcp_project
}
