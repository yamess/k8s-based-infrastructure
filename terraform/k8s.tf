terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.k8s_cluster_name
  region  = var.region
  version = var.k8s_version
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

}