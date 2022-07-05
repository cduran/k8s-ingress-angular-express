#!/bin/bash
export NAMESPACE_NAME=angular-express

# sourcing exported env variables to script
# i=1
# j=$#
# export CUSTOM_K8S_NAMESPACE="dummy-ns"
# while [ $i -le $j ]; do
#     if [ $1 ]; then
#         if [ $1 == '--namespace' ]; then
#             export CUSTOM_K8S_NAMESPACE=$2
#             i=$((i + 2))
#             shift 2
#         fi
#         if [ ! -z $1 ]; then
#             if [ $1 == '--delete' ]; then
#                 export DELETE_FLAG=1
#                 i=$((i + 1))
#                 shift 1
#             fi
#         fi
#     fi
# done
for VARIABLE in ./env-express-app ./env-angular-app ./env-nginx-app
do
    source $VARIABLE

	# substitute env variales in tmpl file and crate a new yaml file with parsed values.
	envsubst < k8s-$DEPLOYMENT_NAME-objects.yaml.tmpl > k8s-$DEPLOYMENT_NAME-objects.final.yaml

	# create defined namespace
	kubectl create namespace $NAMESPACE_NAME

	# apply created yaml
	kubectl apply -f k8s-$DEPLOYMENT_NAME-objects.final.yaml

	# waiting for rollout
	kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE_NAME
done