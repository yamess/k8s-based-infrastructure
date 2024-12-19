terraform {
  cloud {
    organization = "Akuna"
    hostname     = "app.terraform.io"
    workspaces {
      tags = ["workspaces"]
    }
  }


  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}


provider "digitalocean" {
  token             = local.do_token

  spaces_access_id  = local.do_spaces_access_id
  spaces_secret_key = local.do_spaces_secret_key
}

provider "helm" {
    kubernetes {
        host = digitalocean_kubernetes_cluster.this.endpoint
        token = digitalocean_kubernetes_cluster.this.kube_config[0].token
        cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
    }
}

resource "digitalocean_ssh_key" "terraform_ssh_key" {
  name       = "Terraform-managed SSH key for ${local.project}-${local.environment}"
  public_key = local.public_key

  lifecycle {
    prevent_destroy = false
  }
}