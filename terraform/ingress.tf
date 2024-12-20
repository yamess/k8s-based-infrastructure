
resource "null_resource" "install_kubectl" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
      # Create local bin directory if it doesn't exist
      mkdir -p $HOME/.local/bin

      # Add local bin to PATH if not already present
      export PATH=$PATH:$HOME/.local/bin

      # Check if kubectl is already installed
      if ! command -v kubectl &> /dev/null; then
        # Download kubectl binary
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

        # Validate the binary
        curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
        echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

        # Install kubectl to user's local bin
        chmod +x kubectl
        mv kubectl $HOME/.local/bin/

        # Clean up
        rm kubectl.sha256

        # Verify installation
        $HOME/.local/bin/kubectl version --client

        # Add PATH to ~/.bashrc if not already present
        if ! grep -q "$HOME/.local/bin" ~/.bashrc; then
          echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
          source ~/.bashrc
        fi
      fi
      kubectl version --client
    EOT
    interpreter = ["bash", "-c"]
  }

  depends_on = [
    digitalocean_kubernetes_node_pool.node_pools
  ]
}

resource "helm_release" "ingress-controller" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  name  = "ingress-nginx"
  namespace = "ingress-nginx"
  create_namespace = true
  version = "4.11.3"

  values = [file("${local.tools_path}/ingress-nginx/values.yaml")]

  depends_on = [
    null_resource.install_kubectl
  ]
  wait = true
}

resource "helm_release" "certificates" {
  repository = "https://charts.jetstack.io"
  chart = "cert-manager"
  name  = "cert-manager"
  namespace = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [helm_release.ingress-controller]
}

resource "null_resource" "cert-issuer" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = <<-EOT
          kubectl apply -f ${local.tools_path}/cert/issuer-prod.yaml
        EOT
    interpreter = ["bash", "-c"]
    environment = {
      KUBECONFIG = local_sensitive_file.kubeconfig.filename
    }
  }

  depends_on = [helm_release.certificates]
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
        null_resource.cert-issuer
    ]
}


