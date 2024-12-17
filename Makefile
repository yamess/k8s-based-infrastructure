plan:
	terraform -chdir=terraform plan \
		-var-file=tfvars/dev.tfvars \
		-var "do_token=$(DO_PAT)" \
		-var "ssh_pub_key=$$(cat ~/.ssh/rsa.pub)" \
		-var "do_spaces_access_id=$(DO_SPACES_ACCESS_ID)" \
		-var "do_spaces_secret_key=$(DO_SPACES_SECRET_KEY)"

apply:
	terraform -chdir=terraform apply \
		-var-file=tfvars/dev.tfvars \
		-var "do_token=$(DO_PAT)" \
		-var "ssh_pub_key=$$(cat ~/.ssh/rsa.pub)" \
		-var "do_spaces_access_id=$(DO_SPACES_ACCESS_ID)" \
		-var "do_spaces_secret_key=$(DO_SPACES_SECRET_KEY)" \
		-auto-approve

destroy:
	terraform -chdir=terraform destroy \
		-var-file=tfvars/dev.tfvars \
		-var "do_token=$(DO_PAT)" \
		-var "ssh_pub_key=$$(cat ~/.ssh/rsa.pub)" \
		-var "do_spaces_access_id=$(DO_SPACES_ACCESS_ID)" \
		-var "do_spaces_secret_key=$(DO_SPACES_SECRET_KEY)" \
		-auto-approve

ssh:
	ssh-keygen -t ed25519 -C "$(email)" -f ~/.ssh/rsa