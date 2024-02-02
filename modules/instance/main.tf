resource "openstack_networking_floatingip_v2" "this" {
  pool = var.network.floating_ip_pool
}

resource "openstack_compute_instance_v2" "this" {
  name            = var.name
  image_name        = var.image_name
  flavor_name       = var.flavor_name
  key_pair        = var.public_key_pair
  security_groups = var.security_groups

  network {
    name = var.network.name
  }
}

resource "openstack_compute_floatingip_associate_v2" "this" {
  floating_ip = openstack_networking_floatingip_v2.this.address
  instance_id = openstack_compute_instance_v2.this.id
  fixed_ip    = openstack_compute_instance_v2.this.network.0.fixed_ip_v4
}
