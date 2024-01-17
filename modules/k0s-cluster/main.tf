resource "k0s_cluster" "this" {
  name    = "k0s.cluster"
  version = "1.28.5+k0s.0"

  hosts = var.hosts
}
