variable "name" {
  description = "Name of the instance"
}

variable "image_name" {
  description = "Image to use for the instance"
}

variable "flavor_name" {
  description = "Flavor to use for the instance"
}

variable "public_key_pair" {
  description = "Key pair to use for the instance"
}

variable "security_groups" {
  description = "Security groups to use for the instance"

  type = list(string)
}

variable "ssh_login_name" {
  description = "Name of the user to use for SSH access"
}

variable "network" {
  description = "Network to use for the instance"

  type = object({
    name             = string
    floating_ip_pool = string
  })
}
