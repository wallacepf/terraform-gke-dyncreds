provider "google" {
  project = var.gcp_project_id
  region  = "global"
}

data "google_project" "project" {
}

resource "google_project_service" "services" {
  count                      = length(var.gcp_service_list)
  service                    = var.gcp_service_list[count.index]
  disable_dependent_services = true
}

resource "random_id" "id" {
  byte_length = 4
}

resource "google_iam_workload_identity_pool" "tfc_pool" {
  workload_identity_pool_id = "tfc-pool-${random_id.id.hex}"
}

resource "google_iam_workload_identity_pool_provider" "tfc_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "tfc-provider-id-${random_id.id.hex}"

  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri = "https://${var.tfc_hostname}"
  }
  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name_gcp}\")"
}

resource "google_service_account" "tfc_service_account" {
  account_id   = "tfc-service-account"
  display_name = "Terraform Cloud Service Account"
}

resource "google_service_account_iam_member" "tfc_service_account_member" {
  service_account_id = google_service_account.tfc_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc_pool.name}/*"
}

resource "google_service_account_iam_member" "tfc_service_account_sau" {
  service_account_id = google_service_account.tfc_service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc_pool.name}/*"
}

resource "google_project_iam_member" "tfc_project_member" {
  project = var.gcp_project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.tfc_service_account.email}"
}

resource "google_project_iam_member" "tfc_project_k8s_admin" {
  project = var.gcp_project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.tfc_service_account.email}"
}