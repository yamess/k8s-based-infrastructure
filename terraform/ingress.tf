resource "helm_release" "ingress-controller" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  name  = "ingress-nginx"
  namespace = "ingress-nginx"
  create_namespace = true
  version = "4.11.3"

  values = [file("${local.tools_path}/ingress-nginx/values.yaml")]

  depends_on = [
    digitalocean_kubernetes_node_pool.node_pools
  ]
}

resource "null_resource" "ingress" {
    triggers = {
        always_run = timestamp()
    }
    provisioner "local-exec" {
        command = <<-EOT
          kubectl apply -f ${local.tools_path}/ingress-nginx/ingress.yaml
        EOT
        interpreter = ["bash", "-c"]
        environment = {
          KUBECONFIG = local_sensitive_file.kubeconfig.filename
        }
    }

    depends_on = [
        helm_release.ingress-controller,
        null_resource.install_kubectl
    ]
}