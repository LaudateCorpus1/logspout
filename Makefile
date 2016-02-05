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
	mkdir -p build
	docker build -t $(NAME):$(VERSION) .
	docker save $(NAME):$(VERSION) | gzip -9 > build/$(NAME)_$(VERSION).tgz

release:
	docker push bountylabs/progrium_logspout

circleci:
	rm ~/.gitconfig
ifneq ($(CIRCLE_BRANCH), master)
	echo build-$$CIRCLE_BUILD_NUM > VERSION
endif

.PHONY: release
