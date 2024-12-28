resource "helm_release" "prometheus" {
  repository = "https://prometheus-community.github.io/helm-charts"
  chart = "kube-prometheus-stack"
  name  = "prometheus"
  namespace = local.monitoring_namespace
  create_namespace = false

  values = [file("${local.tools_path}/monitoring/prometheus.yaml")]

  depends_on = [
    null_resource.install_kubectl,
    null_resource.create_namespaces,
  ]
}

resource "helm_release" "loki" {
  repository = "https://grafana.github.io/helm-charts"
  chart = "loki-distributed"
  name = "loki"
  namespace = local.monitoring_namespace
  create_namespace = false

  values = [
    file("${local.tools_path}/monitoring/loki.yaml"),
    yamlencode({
      "loki" = {
        "storageConfig" = {
          "aws" = {
            "bucketnames" = digitalocean_spaces_bucket.this.name
            "region" = local.region
            "endpoint" = digitalocean_spaces_bucket.this.endpoint
            "access_key_id" = local.do_spaces_access_id
            "secret_access_key" = local.do_spaces_secret_key
            "s3forcepathstyle" = false
          }
        }
      }
    })
  ]

  depends_on = [
    null_resource.install_kubectl,
    null_resource.create_namespaces
  ]
}

resource "helm_release" "promtail" {
  repository = "https://grafana.github.io/helm-charts"
  chart = "promtail"
  name = "promtail"
  namespace = local.monitoring_namespace
  create_namespace = false
  version = "6.16.6"

  values = [file("${local.tools_path}/monitoring/promtail.yaml")]

  depends_on = [
    null_resource.install_kubectl,
    null_resource.create_namespaces,
    helm_release.loki
  ]
}

resource "null_resource" "demo_apps" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
        kubectl apply -f ${local.tools_path}/demo/frontend-app.yaml -n ${local.frontend_namespace}
        kubectl apply -f ${local.tools_path}/demo/backend-app.yaml -n ${local.backend_namespace}
        kubectl apply -f ${local.tools_path}/demo/private-app.yaml -n ${local.monitoring_namespace}
        EOT
    interpreter = ["bash", "-c"]
    environment = {
      KUBECONFIG = local_sensitive_file.kubeconfig.filename
    }
  }

  depends_on = [
    null_resource.install_kubectl,
    null_resource.create_namespaces
  ]
}
