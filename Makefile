# Define image names and tags for Minikube registry
LOCAL_REGISTRY=iancrichardson10
NGINX_IMAGE=$(LOCAL_REGISTRY)/nginx:latest
PHP_IMAGE=$(LOCAL_REGISTRY)/php:7.2.10-fpm
NETCAT_IMAGE=$(LOCAL_REGISTRY)/netcat:latest

# Default target
all: build-push deploy

# Build all images
build-push: build-push-php build-push-nginx build-push-netcat

# Build Nginx image
build-push-nginx:
	docker buildx build --platform linux/amd64,linux/arm64 -t iancrichardson10/nginx:latest -f src/Dockerfile.nginx . --push

# Build PHP-FPM image
build-push-php:
	docker buildx build --platform linux/amd64,linux/arm64 -t iancrichardson10/php:7.2.10-fpm -f src/Dockerfile.php . --push

# Build Netcat image
build-push-netcat:
	docker buildx build --platform linux/amd64,linux/arm64 -t iancrichardson10/alpine:latest -f src/Dockerfile.netcat . --push

# Clean up local images
clean:
	docker rmi $(NGINX_IMAGE) $(PHP_IMAGE) $(NETCAT_IMAGE)

# Apply Kubernetes manifests
deploy: deploy-php deploy-nginx deploy-netcat

# Apply PHP manifests
deploy-php:
	kubectl apply -f manifests/php-deployment.yaml
	kubectl apply -f manifests/php-service.yaml
	kubectl apply -f manifests/service-account.yaml

# Apply Nginx manifests
deploy-nginx:
	kubectl apply -f manifests/nginx-deployment.yaml
	kubectl apply -f manifests/nginx-service.yaml

# Apply Netcat manifests
deploy-netcat:
	kubectl apply -f manifests/netcat-deployment.yaml
	kubectl apply -f manifests/netcat-service.yaml

# Delete Kubernetes resources
destroy: destroy-php destroy-nginx destroy-netcat

# Delete PHP resources
destroy-php:
	kubectl delete -f manifests/php-deployment.yaml
	kubectl delete -f manifests/php-service.yaml
	kubectl delete -f manifests/service-account.yaml

# Delete Nginx resources
destroy-nginx:
	kubectl delete -f manifests/nginx-deployment.yaml
	kubectl delete -f manifests/nginx-service.yaml

# Delete Netcat resources
destroy-netcat:
	kubectl delete -f manifests/netcat-deployment.yaml
	kubectl delete -f manifests/netcat-service.yaml
