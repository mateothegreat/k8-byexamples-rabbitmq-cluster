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
ADMIN_USER			?= rabbitmq
ADMIN_PASSWORD      ?= agaeq14
REPLICAS			?= 3
export

## Scale rabbitmq pods from the stateful set (make scale REPLICAS=3)
scale: guard-REPLICAS

	kubectl scale statefulset/$(APP) --namespace=$(NS) --replicas=$(REPLICAS)

adduser:

	kubectl exec $(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}') -it -- rabbitmqctl add_user $(ADMIN_USER) $(ADMIN_PASSWORD) 
	kubectl exec $(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}') -it -- rabbitmqctl set_user_tags $(ADMIN_USER) administrator
	kubectl exec $(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}') -it -- rabbitmqctl set_permissions -p / $(ADMIN_USER) ".*" ".*" ".*"