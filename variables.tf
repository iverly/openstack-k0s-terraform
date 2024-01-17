#######################
#      Bootstrap      #
#######################
variable "public_key_pair_path" {
  description = "Path to the public key used for SSH access"
}

variable "ssh_login_name" {
  description = "Name of the user to use for SSH access"
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
}

#######################
#    Control Plane    #
#######################
variable "control_plane_number" {
  description = "Number of control plane instances"
  default     = 1
}

variable "control_plane_image_id" {
  description = "ID of the image to use for the control plane instance"
}

variable "control_plane_flavor_id" {
  description = "ID of the flavor to use for the control plane instance"
}

#######################
#        Worker       #
#######################
variable "worker_number" {
  description = "Number of worker instances"
  default     = 1
}

variable "worker_image_id" {
  description = "ID of the image to use for the worker instance"
}

variable "worker_flavor_id" {
  description = "ID of the flavor to use for the worker instance"
}
