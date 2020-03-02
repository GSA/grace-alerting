GOBIN := $(GOPATH)/bin
GOLANGCILINT := $(GOBIN)/golangci-lint

default: test

test: lint
	apk add --no-cache python3-dev gcc libressl-dev musl-dev libffi-dev
	pip3 install --upgrade pip setuptools flask "moto[server]"
	$(GOBIN) test -v integration_test.go

lint: dependencies
	$(GOLANGCILINT) run ./...

dependencies: $(GOLANGCILINT) go.sum

$(GOLANGCILINT):
	$(GOBIN) get -u github.com/golangci/golangci-lint/cmd/golangci-lint

go.sum: go.mod
	$(GOBIN) mod tidy

go.mod:
	$(GOBIN) mod init