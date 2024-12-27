resource "kubernetes_secret_v1" "this" {
  metadata {
    name = "csi-s3-secret"
    namespace = "kube-system"
  }

  data = {
    accessKeyID = local.do_spaces_access_id
    secretAccessKey = local.do_spaces_secret_key
    endpoint = local.do_space_endpoint
    region = local.region
  }

  depends_on = [
    digitalocean_kubernetes_node_pool.node_pools
  ]
}