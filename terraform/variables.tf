variable "do_token" {
  type = string
  description = "DigitalOcean API token"
}
variable "environment" {
  type = string
  description = "The environment to deploy to"
  default = "dev"
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