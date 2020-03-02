default: test

test: lint
	sudo apt-get install -y python3-dev gcc
	sudo pip3 install --upgrade pip setuptools flask "moto[server]"
	go test -v integration_test.go

lint: dependencies
	golangci-lint run ./...

dependencies: golangci go.sum

golangci:
	go get -u github.com/golangci/golangci-lint/cmd/golangci-lint

go.sum: go.mod
	go mod tidy

go.mod:
	go mod init