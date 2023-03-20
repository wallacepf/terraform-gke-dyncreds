data "google_client_config" "default" {}

# provider "kubernetes" {
#   host                   = "https://${google_container_cluster.primary.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
# }

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "kubernetes_namespace" "vault-injector" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_secret" "vault-sa-token" {
  metadata {
    name      = "vault-token-g955r"
    namespace = kubernetes_namespace.vault-injector.metadata.0.name
    annotations = {
      "kubernetes.io/service-account.name" = "vault"
    }
  }

  type = "kubernetes.io/service-account-token"
  depends_on = [
    helm_release.vault-injector
  ]
}