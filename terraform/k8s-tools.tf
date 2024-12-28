resource "helm_release" "csi-s3" {
  repository = "https://yandex-cloud.github.io/k8s-csi-s3/charts"
  chart = "csi-s3"
  name  = "csi-s3"
  version = "0.42.1"

  depends_on = [
    digitalocean_kubernetes_node_pool.node_pools
  ]
}