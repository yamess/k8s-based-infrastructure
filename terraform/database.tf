resource "helm_release" "qdrant" {
  repository = "https://qdrant.to/helm"
  chart = "qdrant"
  name  = "qdrant"
  namespace = "qdrant"
  create_namespace = true

  values = [file("${local.tools_path}/databases/qdrant.yaml")]

  depends_on = [
    digitalocean_kubernetes_node_pool.node_pools,
    helm_release.csi-s3
  ]
}

# Redis cluster
resource "digitalocean_database_cluster" "redis" {
  engine     = "redis"
  name       = "${local.prefix}-redis-cluster"
  node_count = local.redis_node_count
  region     = local.region
  size       = local.redis_size
  version    = local.redis_version
  private_network_uuid = digitalocean_vpc.this.id
}
resource "digitalocean_database_firewall" "redis-firewall" {
  cluster_id = digitalocean_database_cluster.redis.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.this.id
  }

  depends_on = [digitalocean_kubernetes_cluster.this, digitalocean_database_cluster.redis]
}

# Postgres cluster
resource "digitalocean_database_cluster" "postgres-cluster" {
  engine     = "pg"
  name       = "${local.prefix}-pg-cluster"
  node_count = local.postgres_node_count
  region     = var.region
  size       = local.postgres_size
  version    = local.postgres_version

  storage_size_mib = local.postgres_storage_size

  private_network_uuid = digitalocean_vpc.this.id

  tags = ["database-cluster", "database", "postgres", "pg", local.environment]

}

resource "digitalocean_database_db" "postgres-database" {
  cluster_id = digitalocean_database_cluster.postgres-cluster.id
  name       = "${local.prefix}-pg-db"
}

resource "digitalocean_database_connection_pool" "postgres-pool" {
  cluster_id = digitalocean_database_cluster.postgres-cluster.id
  db_name    = digitalocean_database_db.postgres-database.name
  mode       = "transaction"
  name       = "${local.prefix}-pg-pool"
  size       = local.postgres_pool_size
  user       = digitalocean_database_cluster.postgres-cluster.user
}

resource "digitalocean_database_firewall" "postgres-firewall" {
  cluster_id = digitalocean_database_cluster.postgres-cluster.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.this.id
  }
}