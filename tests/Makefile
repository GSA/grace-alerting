GOBIN := $(GOPATH)/bin
GOLANGCILINT := $(GOBIN)/golangci-lint

default: test

test: lint
	apk add --no-cache python3-dev gcc libressl-dev musl-dev libffi-dev
	pip3 install --upgrade pip setuptools flask "moto[server]"
	go test -v integration_test.go

lint: dependencies
	golangci-lint run ./...

dependencies: $(GOLANGCILINT) go.sum

$(GOLANGCILINT):
	go get -u github.com/golangci/golangci-lint/cmd/golangci-lint

go.sum: go.mod
	go mod tidy

go.mod:
	go mod init