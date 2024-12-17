locals {
  do_token = var.do_token
  environment = var.environment
  do_spaces_access_id = var.do_spaces_access_id
  do_spaces_secret_key = var.do_spaces_secret_key
  ssh_pub_key = var.ssh_pub_key
  project = var.project
  region = var.region
  subnet = var.subnet

  prefix = "${local.project}-${local.region}-${local.environment}"

  k8s_version = "1.31.1-do.5"
}