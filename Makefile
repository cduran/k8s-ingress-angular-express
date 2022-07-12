SHELL = /bin/bash

include env-global

default: build-apps push-apps deploy-to-k8s

cleanup:
	./k8s-util.sh --destroy

build-node-app:
	docker build -f Dockerfile.node \
	--build-arg NODE_APP_PORT=${NODE_APP_PORT} \
	-t ${REGISTRY_HOSTNAME}/${NODE_APP_NAME} .

build-angular-app:
	docker build -f Dockerfile.angular \
	--build-arg NG_APP_PORT=${NG_APP_PORT} \
	-t ${REGISTRY_HOSTNAME}/${ANGULAR_APP_NAME} .

build-nginx-app:
	docker build -f Dockerfile.nginx \
	--build-arg NGINX_APP_HTTP_PORT=${NGINX_APP_HTTP_PORT} \
	--build-arg NGINX_APP_HTTPS_PORT=${NGINX_APP_HTTPS_PORT} \
	--build-arg NG_APP_PORT=${NG_APP_PORT} \
	--build-arg NODE_APP_PORT=${NODE_APP_PORT} \
	-t ${REGISTRY_HOSTNAME}/${NGINX_APP_NAME} .

push-node-app:
	docker push ${REGISTRY_HOSTNAME}/${NODE_APP_NAME}

push-angular-app:
	docker push ${REGISTRY_HOSTNAME}/${ANGULAR_APP_NAME}

push-nginx-app:
	docker push ${REGISTRY_HOSTNAME}/${NGINX_APP_NAME}

build-apps: build-node-app build-angular-app build-nginx-app
push-apps: push-node-app push-angular-app push-nginx-app

deploy-to-k8s:
	./k8s-util.sh --deploy

deploy-to-k8s-output-yaml:
	./k8s-util.sh --deploy --output-temp-yaml