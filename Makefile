#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
include .make/Makefile.inc

NS                  ?= default
APP                 ?= rabbitmq
IMAGE               ?= cluster-4/docker-rabbitmq-autocluster:latest
REMOTE_TAG  		?= gcr.io/streaming-platform-devqa/$(IMAGE)
ADMIN_PASSWORD      ?= P@55w0rd!!
REPLICAS			?= 5
export

## Build docker image
build:  

	$(MAKE) -C docker build
	$(MAKE) -C docker tag_remote

secret:         secret/delete secret/create
secret/delete:  ; kubectl delete secret generic --namespace=$(NS) erlang.cookie | true
secret/create:  ; kubectl create secret generic --namespace=$(NS) erlang.cookie --from-file=./erlang.cookie

## Push docker image using `gcloud`
push-gcloud:

	gcloud docker -- push $(REMOTE_TAG)

## Scale rabbitmq pods from the stateful set (make scale REPLICAS=3)
scale: guard-REPLICAS

	kubectl scale statefulset/$(APP) --namespace=$(NS) --replicas=$(REPLICAS)