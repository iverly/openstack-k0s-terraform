variable "name" {
  description = "Name of the network"
}

variable "cidr" {
  description = "CIDR for the network"
}

variable "external_network_id" {
  description = "ID of the external network"
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
}
