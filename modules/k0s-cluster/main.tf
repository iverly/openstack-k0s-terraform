locals {
  k0s_hosts = [for host in var.hosts : {
    role = host.role
    ssh = {
      address = host.floating_ip_address
      port    = 22
      user    = var.ssh_login_name
    }
  }]

  controler_ips = [for host in var.hosts : "\"${host.floating_ip_address}\", \"${host.private_ip_address}\"" if host.role == "controller"]
}

resource "k0s_cluster" "this" {
  name    = "k0s.cluster"
  version = "1.26.12+k0s.0"

  hosts = local.k0s_hosts

  config = <<EOT
apiVersion: k0s.k0sproject.io/v1beta1
kind: ClusterConfig
metadata:
  name: k0s
spec:
  api:
    sans: [${join(", ", local.controler_ips)}, "127.0.0.1"]
EOT
}
