SHELL = /bin/bash

include env-global

default: build-apps push-apps deploy-to-k8s

cleanup:
	kubectl delete namespace ${NAMESPACE_NAME}

build-node-app:
	docker build -f Dockerfile.node  -t ${REGISTRY_HOSTNAME}/${NODE_APP_NAME} .

build-angular-app:
	docker build -f Dockerfile.angular  -t ${REGISTRY_HOSTNAME}/${ANGULAR_APP_NAME} .

build-nginx-app:
	docker build -f Dockerfile.nginx  -t ${REGISTRY_HOSTNAME}/${NGINX_APP_NAME} .

push-node-app:
	docker push ${REGISTRY_HOSTNAME}/${NODE_APP_NAME}

push-angular-app:
	docker push ${REGISTRY_HOSTNAME}/${ANGULAR_APP_NAME}

push-nginx-app:
	docker push ${REGISTRY_HOSTNAME}/${NGINX_APP_NAME}

build-apps: build-node-app build-angular-app build-nginx-app
push-apps: push-node-app push-angular-app push-nginx-app

deploy-to-k8s:
	./apply-k8s-objects.sh

deploy-to-k8s-remove-temp-yaml:
	./apply-k8s-objects.sh --delete-temp-yaml