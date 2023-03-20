provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# locals {
#   cluster_type           = "simple-autopilot-public"
#   network_name           = "simple-autopilot-public-network"
#   subnet_name            = "simple-autopilot-public-subnet"
#   master_auth_subnetwork = "simple-autopilot-public-master-subnet"
#   pods_range_name        = "ip-range-pods-simple-autopilot-public"
#   svc_range_name         = "ip-range-svc-simple-autopilot-public"
#   subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
# }

# resource "google_container_cluster" "primary" {
#   name     = "${var.gcp_project_id}-gke"
#   location = var.gcp_region

#   network    = module.gcp-network.network_name
#   subnetwork = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
#   release_channel {
#     channel = "REGULAR"
#   }
#   vertical_pod_autoscaling {
#     enabled = true
#   }
#   networking_mode = "VPC_NATIVE"
#   ip_allocation_policy {
#     cluster_secondary_range_name = local.pods_range_name
#     services_secondary_range_name = local.svc_range_name
#   }

#   enable_autopilot = true
# }

locals {
  cluster_type           = "simple-regional"
  network_name           = "simple-regional-public-network"
  subnet_name            = "simple-regional-public-subnet"
  master_auth_subnetwork = "simple-regional-public-master-subnet"
  pods_range_name        = "ip-range-pods-simple-regional-public"
  svc_range_name         = "ip-range-svc-simple-regional-public"
  subnet_names           = [for subnet_self_link in module.gcp-network.subnets_self_links : split("/", subnet_self_link)[length(split("/", subnet_self_link)) - 1]]
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  version                = "25.0.0"
  project_id             = var.gcp_project_id
  name                   = "${var.gcp_project_id}-gke"
  regional               = true
  region                 = var.gcp_region
  network                = module.gcp-network.network_name
  subnetwork             = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods          = local.pods_range_name
  ip_range_services      = local.svc_range_name
  create_service_account = false
  service_account        = var.compute_engine_service_account
  enable_cost_allocation = true
}