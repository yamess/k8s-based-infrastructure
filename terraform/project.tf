resource "digitalocean_project" "this" {
  name = "${local.prefix}-project"

  resources = [
    digitalocean_kubernetes_cluster.this.urn,
  ]
}