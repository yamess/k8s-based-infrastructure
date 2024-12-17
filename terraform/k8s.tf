resource "digitalocean_kubernetes_cluster" "this" {
  name    = "${local.prefix}-k8s-cluster"
  region  = local.region
  version = local.k8s_version
  auto_upgrade = true

  vpc_uuid = digitalocean_vpc.this.id

  maintenance_policy {
    start_time = "04:00"
    day = "sunday"
  }

  node_pool {
    name       = "default"
    size       = "s-1vcpu-2gb"
    node_count = 1
    auto_scale = false
    tags       = ["default"]

    taint {
      effect = "NoSchedule"
      key    = "default"
      value  = "NoSchedule"
    }
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }
}