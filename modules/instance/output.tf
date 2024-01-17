output "access_ip_v4" {
  value = openstack_compute_instance_v2.this.access_ip_v4
}

output "floating_ip_address" {
  value = openstack_networking_floatingip_v2.this.address
}
