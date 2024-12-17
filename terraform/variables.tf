variable "do_token" {
  type = string
  description = "DigitalOcean API token"
}
variable "environment" {
  type = string
  description = "The environment to deploy to"
  default = "dev"
}
variable "region" {
    type = string
    default = "tor1"
    description = "The region to deploy to"
}
variable "do_spaces_access_id" {
  type = string
  description = "DigitalOcean Spaces access ID"
}
variable "do_spaces_secret_key" {
  type = string
  description = "Digital Ocean Spaces secret key"
}
variable "ssh_pub_key" {
  type = string
  description = "The public key to use for SSH access"
}
variable "project" {
  type = string
  description = "The project name"
}

# VPC
variable "subnet" {
  type = string
  description = "The subnet to deploy to"
}

# Kubernetes
variable "node_pools" {
  type = map(object({
    name     = string
    size     = string
    node_count    = number
    auto_scale    = bool
    min_nodes = number
    max_nodes = number
    tags     = list(string)
    service = string
    priority = string
    taint = object({
      key    = string
      value  = string
      effect = string
    })
  }))
  description = "The node pools to create"
}
