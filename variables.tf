#######################
#      Bootstrap      #
#######################
variable "public_key_pair_path" {
  description = "Path to the public key used for SSH access"
  default     = "~/.ssh/id_k0s.pub"
}

variable "ssh_login_name" {
  description = "Name of the user to use for SSH access"
  default     = "debian"
}

variable "openstack_auth_url" {
  description = "URL of the OpenStack authentication endpoint"
  default = "http://overcloud.do.intra:13000"
}

#######################
#       Network       #
#######################
variable "network_cidr" {
  description = "CIDR of the network"
  default     = "192.168.10.0/24"
}

variable "network_floating_ip_pool" {
  description = "Name of the floating IP pool"
  default     = "public"
}

variable "network_external_id" {
  description = "ID of the external network"
  default = "5c4cc7c9-f9d3-4a33-bf4c-919a578b4e6c"
  # default = "71f79016-2ad6-4704-9865-7e9162d27f18"
}

variable "network_dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default = ["10.0.0.3", "8.8.8.8", "8.8.4.4"]
}

#######################
#    Control Plane    #
#######################
variable "control_plane_number" {
  description = "Number of control plane instances"
  default     = 1
}

variable "control_plane_image_name" {
  description = "Name of the image to use for the control plane instance"
  default     = "Debian-12"
}

variable "control_plane_flavor_name" {
  description = "Name of the flavor to use for the control plane instance"
  default = "m1.medium"
}

#######################
#        Worker       #
#######################
variable "worker_number" {
  description = "Number of worker instances"
  default     = 2
}

variable "worker_image_name" {
  description = "Name of the image to use for the worker instance"
  default     = "Debian-12"
}

variable "worker_flavor_name" {
  description = "Name of the flavor to use for the worker instance"
  default     = "m1.medium"
}
