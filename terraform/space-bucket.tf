resource "digitalocean_spaces_bucket" "this" {
  name = "${local.project}-${local.environment}-bucket"
  region = local.region
}

resource "digitalocean_certificate" "this" {
  name = "${local.project}-${local.environment}-cdn-certificate"
  type = "lets_encrypt"
  domains = ["${local.project}-${local.environment}-static.${local.domain}"]

  depends_on = [
    digitalocean_domain.this,
  ]
}

resource "digitalocean_cdn" "this" {
  origin = digitalocean_spaces_bucket.this.bucket_domain_name
  custom_domain = "${local.project}-${local.environment}-static.${local.domain}"
  certificate_name = digitalocean_certificate.this.name

    depends_on = [
        digitalocean_certificate.this,
        digitalocean_spaces_bucket.this,
    ]
}
