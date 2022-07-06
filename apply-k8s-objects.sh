#!/bin/bash
# sourcing exported env variables to script
source env-global

i=1
j=$#
export DELETE_FLAG=0
while [ $i -le $j ]; do
    if [ $1 ]; then
        if [ ! -z $1 ]; then
            if [ $1 == '--delete-temp-yaml' ]; then
                export DELETE_FLAG=1
                i=$((i + 1))
                shift 1
            fi
        fi
    fi
done

# create defined namespace
kubectl create namespace $NAMESPACE_NAME

for VARIABLE in ./env-express-app ./env-angular-app ./env-nginx-app; do
    source $VARIABLE

    # substitute env variales in tmpl file and crate a new yaml file with parsed values.
    envsubst <./k8s-templates/k8s-$DEPLOYMENT_NAME-objects.yaml.tmpl >k8s-$DEPLOYMENT_NAME-objects.final.yaml

    # apply created yaml
    kubectl apply -f k8s-$DEPLOYMENT_NAME-objects.final.yaml
    if [ $DELETE_FLAG == 1 ]; then
        echo "Deleting temp yaml file"
        rm k8s-$DEPLOYMENT_NAME-objects.final.yaml
    fi

    # waiting for rollout
    kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE_NAME
done
