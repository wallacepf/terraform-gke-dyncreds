# output "kubernetes_endpoint" {
#   description = "The cluster endpoint"
#   sensitive   = true
#   value       = google_container_cluster.primary.endpoint
# }

# output "cluster_name" {
#   description = "Cluster name"
#   value       = google_container_cluster.primary.name
# }

# output "location" {
#   value = google_container_cluster.primary.location
# }

# output "master_kubernetes_version" {
#   description = "Kubernetes version of the master"
#   value       = google_container_cluster.primary.master_version
# }

# output "ca_certificate" {
#   sensitive   = true
#   description = "The cluster ca certificate (base64 encoded)"
#   value       = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
# }

# output "network_name" {
#   description = "The name of the VPC being created"
#   value       = module.gcp-network.network_name
# }

# output "subnet_names" {
#   description = "The names of the subnet being created"
#   value       = module.gcp-network.subnets_names
# }

# output "project_id" {
#   description = "The project ID the cluster is in"
#   value       = var.gcp_project_id
# }

# output "vault_token" {
#   sensitive = true
#   value = kubernetes_secret.vault-sa-token.data["token"]
# }

##########

output "kubernetes_endpoint" {
  value     = module.gke.endpoint
  sensitive = true
}

output "vault_token" {
  sensitive = true
  value     = kubernetes_secret.vault-sa-token.data["token"]
}

output "ca_certificate" {
  sensitive = true
  value     = base64decode(module.gke.ca_certificate)
}