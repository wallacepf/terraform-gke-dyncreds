variable "gcp_project_id" {
  description = "The project ID to host the cluster in"
}

variable "gcp_region" {
  description = "The region the cluster in"
  default     = "us-central1"
}

variable "hcp_vault_addr" {
  type = string
}

variable "compute_engine_service_account" {
  type = string
}