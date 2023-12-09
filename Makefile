.PHONY: init
init:			## Start and initialize Kubernetes
	@echo "Starting Kubernetes"
	@minikube start --driver=docker --memory=2000 --cpus=2

	@istioctl install --set profile=default -y
	# TODO: use custom namespace
	@kubectl label namespace default istio-injection=enabled

	@helm install scl-project --generate-name

.PHONY: clear
clear:			## Clear Kubernetes config & Docker images
	@echo "Deleting deployments, services and pods"
	@kubectl delete deployment --all
	@kubectl delete statefulset --all
	@kubectl delete replicaset --all
	@kubectl delete daemonset --all
	@kubectl delete job --all
	@kubectl delete pods --all
	@kubectl delete services --all
	@kubectl delete virtualservices --all
	@kubectl delete secrets --all
	@kubectl delete gateways --all
	@kubectl delete configmaps --all

.PHONY: run
run:				## Run the application
	@echo "Running the application"
	minikube tunnel

.PHONY: helm-install
helm-install:		## Install and run the application with Helm
	@echo "Adding repo"
	@helm repo add st2scl-project https://AbdullatifGhajar.github.io/st2scl-project
	@helm repo update
	
	@echo "Installing the application"
	@helm install scl-project st2scl-project/scl-project

.PHONY: help
help:            		## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep