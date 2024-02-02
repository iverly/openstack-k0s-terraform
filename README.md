# openstack-k0s-terraform

Terraform to deploy a k0s cluster in OpenStack. The goal is to have a terraform script that can be used to deploy a k0s cluster in OpenStack. The script will create a network, a router, a security group, a floating IP, and VMs.

## Requirements

- [Terraform](https://www.terraform.io)
- [OpenStack](https://www.openstack.org) cluster
- [k0s](https://k0sproject.io)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- An OpenStack project with the openrc variables set in the environment
- A public key pair in your computer

## Usage

In order to run the terraform script, you need to set the following variables in the `terraform.tfvars` file:

- `public_key_pair_path`: Path to the public key pair in your computer
- `network_external_id`: ID of the external network in OpenStack
- `network_dns_servers`: DNS servers to use in the network
- `ssh_login_name`: SSH login name for the VMs (eg. ubuntu, centos, etc)
- `openstack_auth_url`: OpenStack auth URL

- `control_plane_image_name`: ID of the image to use for the control plane VMs
- `control_plane_flavor_name`: ID of the flavor to use for the control plane VMs
- `control_plane_number`: Number of control plane VMs to create

- `worker_image_name`: ID of the image to use for the worker VMs
- `worker_flavor_name`: ID of the flavor to use for the worker VMs
- `worker_number`: Number of worker VMs to create

Once the variables are set, you can initialize terraform and run it:

```bash
terraform init
terraform apply
```

> **Note**: The script will create a `terraform.tfstate` file with the state of the cluster. This file is used by terraform to know the state of the cluster. Do **NOT** delete this file. Do **NOT** modify this file manually. Do **NOT** commit this file to a repository.

> **Note**: The `terraform apply` command will use the environment variables `OS_USERNAME`, `OS_PASSWORD`, `OS_TENANT_NAME`, `OS_AUTH_URL` and `OS_REGION_NAME` to connect to OpenStack. These variables can be set using the `source openrc.sh` command.

> **Note**: The `terraform destroy` command will destroy all the resources created by the `terraform apply` command.

Once the script finishes, you can get the IP of the one control plane VMs trough the OpenStack dashboard. Then, you can ssh into the VM and get the kubeconfig file:

```bash
ssh <user>@<control_plane_ip>
sudo k0s kubeconfig admin
```

This will print the kubeconfig file to the terminal. You can copy it to a file and use it to access the cluster:

```bash
echo "<kubeconfig>" > kubeconfig
export KUBECONFIG=kubeconfig
kubectl get nodes
```

> **Note**: Depending on your OpenStack configuration, you might need to change the api server endpoint in the kubeconfig file to the floating IP of the control plane VM.

⚠️ The terraform script will create a security group that will open the SSH port to the world. This is done to let k0sctl access the VMs. Once the cluster is created, you can delete this security group and create a new one that only allows access to the SSH port from your IP, if you want to or just delete it.

## Understanding the terraform

- The first thing the terraform doest is create the key pair associated with the public key in your computer (the one you set in the `public_key_pair_path` variable).

- After, it creates a network, a router and a subnet. The network is connected to the router and the subnet is connected to the network. The router is connected to the external network (the one you set in the `network_external_id` variable). The subnet is created with the cidr `192.168.10.0/24` (that you can change through the `network_cidr` variable).

- Then, it creates a few security groups, including the one that opens the SSH port to the world. A security group is created to access the Kubernetes API from the outside. And two security groups are created to allow the communication between the control plane and the workers and between the workers themselves.

- Creates the instances. The control plane instances are created with the `control_plane_image_name` image and the `control_plane_flavor_name` flavor. The worker instances are created with the `worker_image_name` image and the `worker_flavor_name` flavor. The instances are created with the security groups created before and the key pair created before. The control plane instances are created with the `control_plane_number` variable and the worker instances are created with the `worker_number` variable.

- Finally, it creates the k0s cluster with the k0sctl binary through the ssh connection to the instances.

## Understanding the flux

The terraform script will create a k0s cluster with flux installed. Flux will be configured to use the git repository (you need to change it inside the terraform if you have clone it). This repository contains the kustomize files to deploy the different components of the cluster.

The cluster will have the following components:

- [cert-manager](https://cert-manager.io)
- [weave-gitops](https://github.com/weaveworks/weave-gitops)
- [nginx-ingress](https://kubernetes.github.io/ingress-nginx)
- [cloud-provider-openstack](https://github.com/kubernetes/cloud-provider-openstack) with cloud controller manager and cinder csi driver

## Limitations

- You can only set the control plane number on the first run. If you want to change the number of control plane instances, you need to destroy the cluster and create it again.

- You can scale up or down the number of worker instances, but only for the scale down you have to delete manually the nodes from the cluster. For the scale up, the new nodes will be added automatically to the cluster.

# Contributing

Contributions are welcome. Please follow the standard Git workflow - fork, branch, and pull request.

# License

This project is licensed under the Apache 2.0 - see the `LICENSE` file for details.
