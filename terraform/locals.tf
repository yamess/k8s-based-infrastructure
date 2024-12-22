locals {
	do_token = var.do_token
	environment = var.environment
	do_spaces_access_id = var.do_spaces_access_id
	do_spaces_secret_key = var.do_spaces_secret_key
	public_key = var.public_key
	private_key = var.private_key
	project = var.project
	region = var.region
	subnet = var.subnet
	tools_path = abspath("tools")

	prefix = "${local.project}-${local.region}-${local.environment}"

	ingress_controller_namespace = "nginx"
	certificate_manager_namespace = "cert-manager"
	app_namespace = "backend"
	monitoring_namespace = "monitoring"

	namespaces = toset([
		local.ingress_controller_namespace,
		local.certificate_manager_namespace,
		local.app_namespace,
		local.monitoring_namespace
	])

	k8s_version = "1.31.1-do.5"
	loadbalancer_name = "nginx-load-balancer"

	ttl = 1800
	txt_verification_value = var.txt_verification_value
	mx_value = var.mx_value

	domain = "wouritech.com"
}
