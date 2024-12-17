resource "digitalocean_vpc" "this" {
  name   = "${local.prefix}-vpc"
  region = local.region
  ip_range = local.subnet
}

