variable "hosts" {
  description = "List of hosts to deploy k0s cluster on"
  type = list(object({
    role                = string
    private_ip_address  = string
    floating_ip_address = string
  }))
}

variable "ssh_login_name" {
  description = "SSH user to connect to hosts"
}
