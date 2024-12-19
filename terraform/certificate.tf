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

  depends_on = [null_resource.install_kubectl]
}