variable "cluster_config" {
  description = "The raw Kubernetes cluster configuration"
  type        = string
}

variable "openstack_auth_url" {
  description = "URL of the OpenStack authentication endpoint"
}

variable "network_external_id" {
  description = "ID of the external network"
}

variable "network_internal_subnet_id" {
  description = "ID of the internal subnet"
}
