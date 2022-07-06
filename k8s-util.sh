#!/bin/bash
# sourcing exported env variables to script
source env-global

i=1
j=$#
export OUTPUT_TEMP_YAML_FLAG=0
export DEPLOY_OBJECTS=0
export DESTROY_OBJECTS=0
while [ $i -le $j ]; do
    if [ $1 ]; then
        if [ ! -z $1 ]; then
            if [ "$1" == '--output-temp-yaml' ]; then
                export OUTPUT_TEMP_YAML_FLAG=1
                i=$((i + 1))
                shift 1
            fi
            if [ "$1" == '--deploy' ]; then
                export DEPLOY_OBJECTS=1
                i=$((i + 1))
                shift 1
            fi
            if [ "$1" == '--destroy' ]; then
                export DESTROY_OBJECTS=1
                i=$((i + 1))
                shift 1
            fi
        fi
    fi
done

if [ $DEPLOY_OBJECTS == 1 ]; then 
    # create defined namespace
    envsubst <./k8s-templates/k8s-namespace-object.yaml.tmpl | kubectl apply -f -

    for VARIABLE in ./env-express-app ./env-angular-app ./env-nginx-app; do
        source $VARIABLE

        if [ $OUTPUT_TEMP_YAML_FLAG == 1 ]; then
            # substitute env variales in tmpl file and crate a new yaml file with parsed values.
            envsubst <./k8s-templates/k8s-$DEPLOYMENT_NAME-objects.yaml.tmpl >k8s-$DEPLOYMENT_NAME-objects.final.yaml

            # apply created yaml
            kubectl apply -f k8s-$DEPLOYMENT_NAME-objects.final.yaml
        else
            # substitute and apply yaml in one go.
            envsubst <./k8s-templates/k8s-$DEPLOYMENT_NAME-objects.yaml.tmpl | kubectl apply -f -
        fi

        # waiting for rollout
        kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE_NAME
    done
fi
if [ $DESTROY_OBJECTS == 1 ]; then 
    for VARIABLE in ./env-express-app ./env-angular-app ./env-nginx-app; do
        source $VARIABLE

        # delete all objects.
        envsubst <./k8s-templates/k8s-$DEPLOYMENT_NAME-objects.yaml.tmpl | kubectl delete -f -

        echo "Deleting temp yaml file if any"
        if test -f "k8s-$DEPLOYMENT_NAME-objects.final.yaml"; then
          rm k8s-$DEPLOYMENT_NAME-objects.final.yaml
        fi
    done
    # delete defined namespace
    envsubst <./k8s-templates/k8s-namespace-object.yaml.tmpl | kubectl delete --cascade=orphan -f -
fi
