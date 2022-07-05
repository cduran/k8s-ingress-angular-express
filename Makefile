SHELL = /bin/bash

NAMESPACE_NAME=angular-express

# ifneq (,$(wildcard ./envfile))
#     include envfile
#     export
# endif
# include env-express-app


# source ./env-nginx-app

deployment:
# substitute env variales in tmpl file and crate a new yaml file with parsed values.
	envsubst < k8s-express-app-objects.yaml.tmpl > k8s-express-app-objects.yaml

# create defined namespace
namespace:
# override NAMESPACE_NAME=yes-override
# override NAMESPACE_NAME=double-override
	kubectl create namespace ${NAMESPACE_NAME} --dry-run=client

# # apply created yaml
# kubectl apply -f k8s-objects.final.yaml

# # waiting for rollout
# kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE_NAME

cleanup:
	kubectl delete namespace ${NAMESPACE_NAME}



build-express-app:
	docker build -f Dockerfile.express  -t minikube:5000/express-app .

build-angular-app:
	docker build -f Dockerfile.angular  -t minikube:5000/angular-app .

build-nginx-app:
	docker build -f Dockerfile.nginx  -t minikube:5000/nginx-app .

push-express-app:
	docker push minikube:5000/express-app

push-angular-app:
	docker push minikube:5000/angular-app

push-nginx-app:
	docker push minikube:5000/nginx-app

build-to-minikube: build-express-app build-angular-app build-nginx-app
push-to-minikube: push-express-app push-angular-app	push-nginx-app
