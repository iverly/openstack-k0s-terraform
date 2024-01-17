resource "openstack_networking_router_v2" "this" {
  name                = "${var.name}.router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "openstack_networking_network_v2" "this" {
  name = var.name
}

resource "openstack_networking_subnet_v2" "this" {
  name       = "${var.name}.subnet"
  network_id = openstack_networking_network_v2.this.id
  cidr       = var.cidr
}

resource "openstack_networking_router_interface_v2" "this" {
  router_id = openstack_networking_router_v2.this.id
  subnet_id = openstack_networking_subnet_v2.this.id
}
