plan:
	terraform -chdir=terraform plan -var-file=tfvars/dev.tfvars

apply:
	terraform -chdir=terraform apply -var-file=tfvars/dev.tfvars -auto-approve
	terraform -chdir=terraform output -raw k8s_config > ~/.kube/config

destroy:
	terraform -chdir=terraform destroy -var-file=tfvars/dev.tfvars -auto-approve

ssh:
	ssh-keygen -t ed25519 -C "$(email)" -f ~/.ssh/rsa

export-values:
	helm show values $(CHART) > $(FILENAME)