variable "project" {
  description = "GCP project"
  type = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type = string
}

variable "region" {
  description = "GKE region"
  type = string
}

variable "location" {
  description = "GKE subregion"
  type = string
}

variable "daily_maintenance_window_start_time" {
  type = string
}

variable "cluster_range_name" {
  description = "Secondary range name in the cluster's subnetwork to use for pod IP addresses"
  type = string
}

variable "cluster_range_cidr" {
  description = "Address range of the subnetwork, in which cluster nodes will run"
  type = string
}

variable "services_range_name" {
  description = "Secondary range name in the cluster's subnetwork to use for pod IP addresses"
  type = string
}

variable "services_range_cidr" {
  description = "Address range of the subnetwork, in which our k8s services will run"
  type = string
}

variable "subnet_cidr_range" {
  description = "Address range of the subnetwork, in which our GKE cluster will run"
  type = string
}

variable "private_ip_google_access" {
  description = "Allow VMs without external IP to access Google APIs through Private Google Access"
  type    = bool
  default = true
}

# internal IP adddresses of masters
variable "master_ipv4_cidr_block" {
  description = "Address range of the subnetwork for cluster's master node"
  type = string
}

# IAM for storage.objectViewer
# access GCR private images
variable "access_private_images" {
  type    = bool
  default = false
}

# HTTP (L7) load balancer
variable "http_load_balancing_disabled" {
  type    = bool
  default = false
}

variable "master_authorized_networks_cidr_blocks" {
  type = list(map(string))

  default = [
    {
      # external access to k8s master HTTPS
      cidr_block   = "0.0.0.0/0"
      display_name = "default"
    }
  ]
}

variable "enable_service_apis" {
  description = "Which API services to enable in GCP? Eg. cloudresourcemanager.googleapis.com"
  type        = set(string)
  default     = []
}

variable "logging_service" {
  description = "Logging service"
  type    = string
  default = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "monitoring"
  type    = string
  default = "monitoring.googleapis.com/kubernetes"
}

variable "enable_private_nodes" {
  description = "Enable private nodes on the cluster"
  type    = bool
  default = true
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint on the cluster"
  type    = bool
  default = false
}

#https://www.terraform.io/docs/providers/google/r/container_node_pool.html
variable "node_pools" {
  description = "Node pool configuration"
  type    = map(map(string))
  default = {}
}

#https://www.terraform.io/docs/providers/google/r/container_cluster.html#taint
variable "node_pools_taints" {
  description = "Node pool taints"
  type = map(list(object({ key = string, value = string, effect = string })))
  default = {
    custom-node-pool = []
  }
}

variable "node_pools_tags" {
  description = "The list of instance tags applied to all nodes"
  type = map(list(string))
  default = {
    custom-node-pool = []
  }
}

#https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes-1
variable "node_pools_oauth_scopes" {
  description = "Set of Google API scopes to be made available on all of the node"
  type = map(list(string))
}

#AUTO_ONLY, MANUAL_ONLY
variable "nat_ip_allocate_option" {
  description = "External IPs allocation option"
  type = string
}

# ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS
variable "source_subnetwork_ip_ranges_to_nat" {
  description = "How NAT should be configured per Subnetwork"
  type = string
}

# ALL_IP_RANGES, LIST_OF_SECONDARY_IP_RANGES, PRIMARY_IP_RANGE
variable "source_ip_ranges_to_nat" {
  description = "List of options for which source IPs in the subnetwork should have NAT enabled"
  type = list
}

variable "nat_log_filter" {
  description = "List of options for which source IPs in the subnetwork should have NAT enabled"
  type = string
}
