# NAME	= a ppsoa/docker-alpine-rabbitmq
# ALIAS	= rabbitmq
# VERSION	= 1.0.0
include ../.make/Makefile.inc

.PHONY:	all build test tag_latest release

all:	clean build

build: guard-APP guard-IMAGE

	@echo "Building an image with the current tag $(IMAGE).."
	
	docker build 	--rm 	\
					--tag $(IMAGE) \
					.

run:

	docker run 	--rm -it 				                        \
				--volume $(PWD)/jenkins_home:/var/jenkins_home 	\
				--publish 8080:8080		                        \
				--publish 50000:50000                           \
				--name $(ALIAS)                                 \
				$(NAME):$(VERSION)
	
shell:

	docker run 	--rm -it 				                        \
				--volume $(PWD)/jenkins_home:/var/jenkins_home 	\
				--publish 8080:8080		                        \
				--publish 50000:50000                           \
				--name $(ALIAS)                                 \
				--entrypoint /bin/sh                            \
				$(NAME):$(VERSION)

tag_remote:

	docker tag $(IMAGE) $(REMOTE_TAG)

release:

	docker push $(NAME)
