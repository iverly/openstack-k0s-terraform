#######################
#         SSH         #
#######################
resource "openstack_networking_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "Allow SSH from anywhere - Recommended to delete after deployment"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.ssh.id
}

#######################
#         HTTP        #
#######################
resource "openstack_networking_secgroup_v2" "http" {
  name        = "http"
  description = "Allow HTTP/HTTPS from anywhere"
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.http.id
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 443
  port_range_max   = 443
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.http.id
}

#######################
#  Control Plane API  #
#######################
resource "openstack_networking_secgroup_v2" "control_plane_api" {
  name        = "control-plane-api"
  description = "Allow API traffic to control plane api"
}

resource "openstack_networking_secgroup_rule_v2" "control_plane_api" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min   = 6443
  port_range_max   = 6443
  remote_ip_prefix = "0.0.0.0/0"

  security_group_id = openstack_networking_secgroup_v2.control_plane_api.id
}

#######################
#  Controller-Worker  #
#######################
resource "openstack_networking_secgroup_v2" "controller" {
  name        = "controller"
  description = "Allow traffic for controller->worker nodes"
}

resource "openstack_networking_secgroup_v2" "worker" {
  name        = "worker"
  description = "Allow traffic for worker->controller nodes"
}

// etcd peers
resource "openstack_networking_secgroup_rule_v2" "etcd_peers_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 2380
  port_range_max  = 2380
  remote_group_id = openstack_networking_secgroup_v2.worker.id

  security_group_id = openstack_networking_secgroup_v2.controller.id
}

resource "openstack_networking_secgroup_rule_v2" "etcd_peers_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 2380
  port_range_max  = 2380
  remote_group_id = openstack_networking_secgroup_v2.controller.id

  security_group_id = openstack_networking_secgroup_v2.worker.id
}

// kube api server
resource "openstack_networking_secgroup_rule_v2" "kube_api_server" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 6443
  port_range_max  = 6443
  remote_group_id = openstack_networking_secgroup_v2.worker.id

  security_group_id = openstack_networking_secgroup_v2.controller.id
}

// kube-router
resource "openstack_networking_secgroup_rule_v2" "kube_router" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "udp"

  port_range_min  = 179
  port_range_max  = 179
  remote_group_id = openstack_networking_secgroup_v2.worker.id

  security_group_id = openstack_networking_secgroup_v2.worker.id
}

// kubelet
resource "openstack_networking_secgroup_rule_v2" "kubelet_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 10250
  port_range_max  = 10250
  remote_group_id = openstack_networking_secgroup_v2.worker.id

  security_group_id = openstack_networking_secgroup_v2.controller.id
}

resource "openstack_networking_secgroup_rule_v2" "kubelet_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 10250
  port_range_max  = 10250
  remote_group_id = openstack_networking_secgroup_v2.controller.id

  security_group_id = openstack_networking_secgroup_v2.worker.id
}

resource "openstack_networking_secgroup_rule_v2" "kubelet_3" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 10250
  port_range_max  = 10250
  remote_group_id = openstack_networking_secgroup_v2.controller.id

  security_group_id = openstack_networking_secgroup_v2.controller.id
}

resource "openstack_networking_secgroup_rule_v2" "kubelet_4" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 10250
  port_range_max  = 10250
  remote_group_id = openstack_networking_secgroup_v2.worker.id

  security_group_id = openstack_networking_secgroup_v2.worker.id
}

// k0s-api
resource "openstack_networking_secgroup_rule_v2" "k0s_api" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 9443
  port_range_max  = 9443
  remote_group_id = openstack_networking_secgroup_v2.controller.id

  security_group_id = openstack_networking_secgroup_v2.controller.id
}

// konnectivity
resource "openstack_networking_secgroup_rule_v2" "konnectivity_1" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 8132
  port_range_max  = 8132
  remote_group_id = openstack_networking_secgroup_v2.worker.id

  security_group_id = openstack_networking_secgroup_v2.controller.id
}

resource "openstack_networking_secgroup_rule_v2" "konnectivity_2" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  port_range_min  = 8132
  port_range_max  = 8132
  remote_group_id = openstack_networking_secgroup_v2.controller.id

  security_group_id = openstack_networking_secgroup_v2.worker.id
}
