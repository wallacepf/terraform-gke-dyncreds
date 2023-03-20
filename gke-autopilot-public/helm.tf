# provider "helm" {
#   kubernetes {
#     host = "https://${google_container_cluster.primary.endpoint}"
#     cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
#     token = data.google_client_config.default.access_token
#   }
# }

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}


resource "helm_release" "vault-injector" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.23.0"
  namespace  = kubernetes_namespace.vault-injector.metadata.0.name

  set {
    name  = "injector.enabled"
    value = true
  }

  set {
    name  = "injector.image.repository"
    value = "hashicorp/vault-k8s"
  }

  set {
    name  = "injector.image.tag"
    value = "latest"
  }

  set {
    name  = "injector.externalVaultAddr"
    value = var.hcp_vault_addr
  }

  depends_on = [
    # google_container_cluster.primary,
    module.gke,
    kubernetes_namespace.vault-injector,
  ]
}