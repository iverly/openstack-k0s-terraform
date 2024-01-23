output "ssh_name" {
  value = openstack_networking_secgroup_v2.ssh.name
}

output "http_name" {
  value = openstack_networking_secgroup_v2.http.name
}

output "control_plane_api_name" {
  value = openstack_networking_secgroup_v2.control_plane_api.name
}

output "controller_name" {
  value = openstack_networking_secgroup_v2.controller.name
}

output "worker_name" {
  value = openstack_networking_secgroup_v2.worker.name
}
