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

resource "digitalocean_kubernetes_node_pool" "node_pools" {
  for_each = var.node_pools
  cluster_id = digitalocean_kubernetes_cluster.this.id

  name       = each.value.name
  size       = each.value.size
  node_count = each.value.node_count
  auto_scale = each.value.auto_scale

  min_nodes = each.value.auto_scale ? each.value.min_nodes : null
  max_nodes = each.value.auto_scale ? each.value.max_nodes : null

  tags = each.value.tags

  labels = {
    service  = each.value.service
    priority = each.value.priority
  }

  dynamic "taint" {
    for_each = each.value.taint != null ? [each.value.taint] : []
    content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
    }
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }
}