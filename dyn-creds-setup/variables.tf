variable "tfc_gcp_audience" {
  type        = string
  default     = ""
  description = "The audience value to use in run identity tokens if the default audience value is not desired."
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with AWS"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_project_name" {
  type        = string
  default     = "Default Project"
  description = "The project under which a workspace will be created"
}

variable "tfc_workspace_name_gcp" {
  type        = string
  default     = "dynamic-credentials-trust-relationship"
  description = "The name of the workspace that you'd like to create and connect to GCP"
}

variable "tfc_workspace_name_vault" {
  type        = string
  default     = "dynamic-credentials-trust-relationship"
  description = "The name of the workspace that you'd like to create and connect to Vault"
}

variable "gcp_project_id" {
  type        = string
  description = "The ID for your GCP project"
}

variable "gcp_service_list" {
  description = "APIs required for the project"
  type        = list(string)
  default = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com",
    "container.googleapis.com"
  ]
}

variable "hcp_vault_addr" {
  type        = string
  description = "Address of your HCP Vault Instance"
}

variable "jwt_backend_path" {
  type        = string
  default     = "jwt"
  description = "The path at which you'd like to mount the jwt auth backend in Vault"
}

variable "tfc_vault_audience" {
  type        = string
  default     = "vault.workload.identity"
  description = "The audience value to use in run identity tokens"
}

variable "vault_gke_namespace" {
  type = string
}