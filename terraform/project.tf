resource "digitalocean_project" "this" {
  name = "${local.prefix}-project"

  resources = [
    digitalocean_kubernetes_cluster.this.urn,
    digitalocean_domain.this.urn,
    digitalocean_spaces_bucket.this.urn,
    digitalocean_database_cluster.redis.urn
  ]
}