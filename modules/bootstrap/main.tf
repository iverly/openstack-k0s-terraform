resource "openstack_compute_keypair_v2" "this" {
  name       = var.public_key_pair_name
  public_key = file(var.public_key_pair_path)
}
