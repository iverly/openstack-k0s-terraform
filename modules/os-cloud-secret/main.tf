resource "openstack_identity_application_credential_v3" "this" {
  name  = "k0s-cloud-credentials"
  roles = ["reader", "member", "load-balancer_member"]
}

locals {
  cloud_config = <<EOF
[Global]
auth-url = ${var.openstack_auth_url}
application-credential-id = ${openstack_identity_application_credential_v3.this.id}
application-credential-secret = ${openstack_identity_application_credential_v3.this.secret}
region = ${openstack_identity_application_credential_v3.this.region}
tls-insecure = true

[LoadBalancer]
use-octavia=true
floating-network-id=${var.network_external_id}
subnet-id=${var.network_internal_subnet_id}
EOF
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "os-cloud-credentials"
    namespace = "kube-system"
  }

  data = {
    "cloud.conf" = local.cloud_config
  }

  depends_on = [openstack_identity_application_credential_v3.this]
}
