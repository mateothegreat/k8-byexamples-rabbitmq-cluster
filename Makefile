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

## Scale rabbitmq pods from the stateful set (make scale REPLICAS=3)
scale: guard-REPLICAS

	kubectl scale statefulset/$(APP) --namespace=$(NS) --replicas=$(REPLICAS)