terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.50.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.42.0"
    }
  }
}