project = "akuna"
environment = "dev"
subnet = "10.100.10.0/24"

node_pools = {
  general = {
    name      = "general"
    size      = "s-2vcpu-4gb"
    node_count = 1
    auto_scale = false
    min_nodes = 0
    max_nodes = 0
    tags      = ["general"]
    service   = "general"
    priority  = "high"
    taint = null
  }
}
