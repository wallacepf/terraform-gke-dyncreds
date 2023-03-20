provider "tfe" {

}

resource "tfe_project" "my-project" {
  name         = var.tfc_project_name
  organization = var.tfc_organization_name
}

resource "tfe_workspace" "my-wksp" {
  name         = var.tfc_workspace_name_gcp
  organization = var.tfc_organization_name
  project_id   = tfe_project.my-project.id
  remote_state_consumer_ids = [tfe_workspace.hcp-vault-configs.id]
}

resource "tfe_variable_set" "gcp-creds" {
  name         = "GCP Creds"
  description  = "GCP Credentials"
  organization = var.tfc_organization_name
}

resource "tfe_workspace_variable_set" "gcp-vs" {
  workspace_id    = tfe_workspace.my-wksp.id
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "TFC_GCP_PROVIDER_AUTH" {
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "gcp_region" {
  key             = "gcp_region"
  value           = "us-central1"
  category        = "terraform"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "gcp_project_id" {
  key             = "gcp_project_id"
  value           = var.gcp_project_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "vault_addr" {
  key             = "VAULT_ADDR"
  value           = var.hcp_vault_addr
  category        = "env"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "vault_addr_tf" {
  key             = "hcp_vault_addr"
  value           = var.hcp_vault_addr
  category        = "terraform"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "TFC_GCP_PROJECT_NUMBER" {
  key             = "TFC_GCP_PROJECT_NUMBER"
  value           = data.google_project.project.number
  category        = "env"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL" {
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = google_service_account.tfc_service_account.email
  category        = "env"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "TFC_GCP_WORKLOAD_POOL_ID" {
  key             = "TFC_GCP_WORKLOAD_POOL_ID"
  value           = google_iam_workload_identity_pool.tfc_pool.workload_identity_pool_id
  category        = "env"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_variable" "TFC_GCP_WORKLOAD_PROVIDER_ID" {
  key             = "TFC_GCP_WORKLOAD_PROVIDER_ID"
  value           = google_iam_workload_identity_pool_provider.tfc_provider.workload_identity_pool_provider_id
  category        = "env"
  variable_set_id = tfe_variable_set.gcp-creds.id
}

resource "tfe_workspace" "hcp-vault-configs" {
  name         = "hcp-vault-configs-demo"
  organization = var.tfc_organization_name
  project_id   = tfe_project.my-project.id
}

resource "tfe_variable_set" "vault-creds" {
  name         = "Vault Creds"
  description  = "Vault Credentials"
  organization = var.tfc_organization_name
}

resource "tfe_workspace_variable_set" "vault-vs" {
  workspace_id    = tfe_workspace.hcp-vault-configs.id
  variable_set_id = tfe_variable_set.vault-creds.id
}

resource "tfe_variable" "TFC_VAULT_PROVIDER_AUTH" {
  key             = "TFC_VAULT_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.vault-creds.id
}

resource "tfe_variable" "TFC_VAULT_ADDR" {
  key             = "TFC_VAULT_ADDR"
  value           = var.hcp_vault_addr
  category        = "env"
  variable_set_id = tfe_variable_set.vault-creds.id
}

resource "tfe_variable" "TFC_VAULT_RUN_ROLE" {
  key             = "TFC_VAULT_RUN_ROLE"
  value           = vault_jwt_auth_backend_role.tfc_role.role_name
  category        = "env"
  variable_set_id = tfe_variable_set.vault-creds.id
}

resource "tfe_variable" "TFC_VAULT_NAMESPACE" {
  key             = "TFC_VAULT_NAMESPACE"
  value           = "admin"
  category        = "env"
  variable_set_id = tfe_variable_set.vault-creds.id
}