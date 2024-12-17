resource "digitalocean_project" "this" {
  name = "${local.prefix}-project"

  resources = [
    digitalocean_vpc.this.urn,
    digitalocean_kubernetes_cluster.this.urn,
  ]
}