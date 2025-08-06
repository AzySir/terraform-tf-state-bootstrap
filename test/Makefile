
APP:=myapp
ORG:=myorg
REMOTE_BACKEND:=true

fmt:
	terraform fmt -recursive

clean:
	rm -rf .terraform*

init: validate-aws validate-env validate-region clean
ifeq ($(REMOTE_BACKEND), false)
	terraform init 
else
	terraform init \
	-backend-config=bucket=$(ORG)-$(APP)-$(REGION)-tf-state \
	-backend-config=key="$(APP)/$(ENV)/$(REGION)/terraform.tfstate" \
	-backend-config=region=$(REGION) \
	$(ARGS)
endif

plan: validate-aws validate-env validate-region fmt
	terraform plan \
	-var-file=$(ENV).tfvars \
	-var-file=$(ENV)_$(REGION).tfvars \
	$(ARGS)

apply: validate-aws validate-env validate-region fmt
	terraform apply \
	-var-file=$(ENV).tfvars \
	-var-file=$(ENV)_$(REGION).tfvars \
	$(ARGS)

destroy: validate-aws validate-env validate-region fmt
	terraform destroy \
	-var-file=$(ENV).tfvars \
	-var-file=$(ENV)_$(REGION).tfvars \
	$(ARGS)

console: validate-aws validate-env fmt
	terraform console \
	-var-file=$(ENV).tfvars \
	-var-file=$(ENV)_$(REGION).tfvars \
	$(ARGS)

validate-aws:
ifndef AWS_SECRET_ACCESS_KEY
	$(error Please authenticate to AWS i.e AWS_SECRET_ACCESS_KEY="<secret key here>")
endif
ifndef AWS_ACCESS_KEY_ID
	$(error Please authenticate to AWS i.e AWS_ACCESS_KEY_ID="<access key here>")
endif

validate-env:
ifndef ENV
	$(error Please provide a Environment Name i.e make plan ENV="dev")
endif

validate-region: 
ifndef REGION
	$(error Please provide a Region Name i.e make plan REGION="eu-west-2" ENV="dev")
endif
