.PHONY: init
init:			## Start and initialize Kubernetes
	@echo "Starting Kubernetes"
	@minikube start --driver=docker

	@echo "Installing Ingress"
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
	@minikube addons enable ingress
	
	@echo "Applying Kubernetes config"
	@kubectl apply -f k8s
	@kubectl apply -f k8s/database
	@kubectl apply -f k8s/frontend
	@kubectl apply -f k8s/backend

.PHONY: clear
clear:			## Clear Kubernetes config & Docker images
	@echo "Deleting deployments, services and pods"
	@kubectl delete deployment --all
	@kubectl delete statefulset --all
	@kubectl delete replicaset --all
	@kubectl delete daemonset --all
	@kubectl delete job --all
	@kubectl delete pods --all --all-namespaces

	@echo "Deleting docker images from Minikube"
	@minikube image rm abdullatifghajar/st2scl-project-frontend:latest
	@minikube image rm abdullatifghajar/st2scl-project-backend:latest
	@minikube image rm abdullatifghajar/st2scl-project-db:latest

.PHONY: run
run:				## Run the application
	@echo "Running the application"
	minikube tunnel

.PHONY: help
help:            		## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep