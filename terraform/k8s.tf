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

  node_pool {
      name       = "default"
      size       = "s-1vcpu-2gb"
      node_count = 1
  }
}