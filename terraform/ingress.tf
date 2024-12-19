resource "helm_release" "ingress-controller" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  name  = "ingress-nginx"
  namespace = "ingress-nginx"
  create_namespace = true

  set {
      name  = "controller.publishService.enabled"
      value = "true"
  }

  depends_on = [
    digitalocean_kubernetes_cluster.this
  ]
}