module "bootstrap" {
  source = "./modules/bootstrap"

  public_key_pair_name = "k0s"
  public_key_pair_path = var.public_key_pair_path
}

module "network" {
  source = "./modules/network"

  name                = "k0s"
  cidr                = var.network_cidr
  external_network_id = var.network_external_id

  depends_on = [module.bootstrap]
}

module "security_groups" {
  source = "./modules/security-groups"
}

module "control_plane" {
  source = "./modules/instance"
  count  = var.control_plane_number

  name      = "k0s.control-plane.${count.index}"
  image_id  = var.control_plane_image_id
  flavor_id = var.control_plane_flavor_id

  public_key_pair = module.bootstrap.public_key_pair_name
  ssh_login_name  = var.ssh_login_name

  security_groups = [
    module.security_groups.ssh_name,
    module.security_groups.control_plane_api_name,
    module.security_groups.controller_name
  ]

  network = {
    name             = module.network.name
    floating_ip_pool = var.network_floating_ip_pool
  }

  depends_on = [module.bootstrap, module.network, module.security_groups]
}

module "worker" {
  source = "./modules/instance"
  count  = var.worker_number

  name      = "k0s.worker.${count.index}"
  image_id  = var.worker_image_id
  flavor_id = var.worker_flavor_id

  public_key_pair = module.bootstrap.public_key_pair_name
  ssh_login_name  = var.ssh_login_name

  security_groups = [
    module.security_groups.ssh_name,
    module.security_groups.worker_name
  ]

  network = {
    name             = module.network.name
    floating_ip_pool = var.network_floating_ip_pool
  }

  depends_on = [module.bootstrap, module.network, module.security_groups]
}

module "k0s-cluster" {
  source = "./modules/k0s-cluster"

  hosts = concat(
    [for instance in module.control_plane : {
      role = "controller"
      ssh = {
        address  = instance.floating_ip_address
        port     = 22
        user     = var.ssh_login_name
        key_path = var.public_key_pair_path
      }
    }],
    [for instance in module.worker : {
      role = "worker"
      ssh = {
        address  = instance.floating_ip_address
        port     = 22
        user     = var.ssh_login_name
        key_path = var.public_key_pair_path
      }
    }]
  )

  depends_on = [module.bootstrap, module.network, module.security_groups, module.control_plane, module.worker]
}
