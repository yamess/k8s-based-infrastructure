data "digitalocean_loadbalancer" "loadbalancer" {
  name = local.loadbalancer_name

  depends_on = [helm_release.ingress-controller]
}

resource "digitalocean_domain" "this" {
  name = local.domain

  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }
}

resource "digitalocean_record" "main" {
  domain = local.domain
  name   = "@"
  type   = "A"
  value  = data.digitalocean_loadbalancer.loadbalancer.ip
  ttl = local.ttl

  depends_on = [digitalocean_domain.this]
}

resource "digitalocean_record" "www" {
  domain = local.domain
  name   = "www"
  type   = "CNAME"
  value  = "@"
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}

resource "digitalocean_record" "api" {
  domain = local.domain
  name   = "api"
  type   = "A"
  value  = data.digitalocean_loadbalancer.loadbalancer.ip
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}

resource "digitalocean_record" "internal" {
  domain = local.domain
  name   = "internal"
  type   = "A"
  value  = data.digitalocean_loadbalancer.loadbalancer.ip
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}

resource "digitalocean_record" "grafana" {
  domain = local.domain
  name   = "grafana"
  type   = "A"
  value  = data.digitalocean_loadbalancer.loadbalancer.ip
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}

### Email Configuration
resource "digitalocean_record" "txt_spf" {
  domain = local.domain
  name   = "@"
  type   = "TXT"
  value  = "v=spf1 include:secureserver.net -all"
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}
resource "digitalocean_record" "txt_verification" {
  domain = local.domain
  name   = "@"
  type   = "TXT"
  value  = local.txt_verification_value
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}
resource "digitalocean_record" "mx" {
  domain = local.domain
  name   = "@"
  type   = "MX"
  value  = local.mx_value
  priority = 0
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}
resource "digitalocean_record" "cname_1" {
  domain = local.domain
  name   = "autodiscover"
  type   = "CNAME"
  value  = "autodiscover.outlook.com."
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}
resource "digitalocean_record" "cname_2" {
  domain = local.domain
  name   = "email"
  type   = "CNAME"
  value  = "email.secureserver.net."
  ttl = local.ttl

  depends_on = [digitalocean_record.main]
}