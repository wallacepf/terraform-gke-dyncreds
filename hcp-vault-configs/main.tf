provider "vault" {
}

data "tfe_outputs" "gke" {
  organization = var.tfc_org
  workspace = var.gke_wrksp
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = "gke"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend                = vault_auth_backend.kubernetes.path
  token_reviewer_jwt = data.tfe_outputs.gke.values.vault_token
  kubernetes_ca_cert = data.tfe_outputs.gke.values.ca_certificate
  kubernetes_host = "https://${data.tfe_outputs.gke.values.kubernetes_endpoint}"
  issuer       = "https://kubernetes.default.svc.cluster.local"
  disable_iss_validation = true
}

resource "vault_kubernetes_auth_backend_role" "vaulidate-file" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vaulidate-file"
  bound_service_account_names      = ["vaulidate-file"]
  bound_service_account_namespaces = ["vaulidate-file"]
  token_ttl                        = 3600
  token_policies                   = ["default", "vaulidate"]
}

resource "vault_policy" "vaulidate_policy" {
  name = "vaulidate"

  policy = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

path "gke/data/vaulidate/mysecret" {
  capabilities = ["read"]
}

EOT
}

resource "vault_mount" "example" {
  path    = "gke"
  type    = "kv-v2"
  options = { version = "2" }
}

resource "vault_kv_secret_v2" "example" {
  mount = vault_mount.example.path

  name                = "vaulidate/mysecret"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username = "foo",
      password = "bar"
    }
  )
}