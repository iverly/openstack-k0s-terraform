variable "hosts" {
  description = "List of hosts to deploy k0s cluster on"
  type = list(object({
    role = string

    ssh = object({
      address  = string
      port     = number
      user     = string
      key_path = string
    })
  }))
}
