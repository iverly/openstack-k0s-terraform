output "name" {
  value = var.name
}

output "subnet_id" {
  value = openstack_networking_subnet_v2.this.id
}
