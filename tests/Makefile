test: init 
	apk add --no-cache python3-dev gcc libressl-dev musl-dev libffi-dev
	pip3 install --upgrade pip setuptools flask "moto[server]"
	go test -v integration_test.go

apply: plan
	terraform apply -auto-approve

plan: validate
	terraform plan

validate: init
	terraform validate
	terrascan --location . --tests all

init:
	terraform init
	go mod tidy
	[[ -d ../release ]] || mkdir ../release