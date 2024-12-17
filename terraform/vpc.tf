terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_vpc" "this" {
  name   = "${local.project}-${local.region}-${local.environment}-vpc"
  region = local.region
  ip_range = local.subnet
}

