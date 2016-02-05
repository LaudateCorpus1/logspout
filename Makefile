NAME=logspout
VERSION=$(shell cat VERSION)

dev:
	@docker history $(NAME):dev &> /dev/null \
		|| docker build -f Dockerfile.dev -t $(NAME):dev .
	@docker run --rm \
		-e DEBUG=true \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(PWD):/go/src/github.com/bountylabs/logspout \
		-p 8000:80 \
		-e ROUTE_URIS=$(ROUTE) \
		$(NAME):dev

build:
	go get github.com/tools/godep
	CGO_ENABLED=0 godep go build -a --installsuffix cgo --ldflags='-extldflags=-static'
	docker build -t bountylabs/progrium_logspout:latest .

release:
	docker push bountylabs/progrium_logspout:latest

circleci:
	rm ~/.gitconfig
ifneq ($(CIRCLE_BRANCH), master)
	echo build-$$CIRCLE_BUILD_NUM > VERSION
endif

.PHONY: release
