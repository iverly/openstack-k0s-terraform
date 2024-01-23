variable "cluster_config" {
  description = "The raw Kubernetes cluster configuration"
  type        = string
}

variable "openstack_auth_url" {
  description = "URL of the OpenStack authentication endpoint"
}
