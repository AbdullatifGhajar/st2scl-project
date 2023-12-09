KUBERNETES_NAMESPACE=scl-project

.PHONY: init
init:			## Start and initialize Kubernetes
	@echo "Starting Minikube"
	@minikube start --driver=docker --memory=2000 --cpus=2

	@echo "Creating namespace $(KUBERNETES_NAMESPACE)"
	@kubectl create namespace $(KUBERNETES_NAMESPACE)

	@echo "Setting update Istio"
	@istioctl install --set profile=default -y
	@kubectl label namespace $(KUBERNETES_NAMESPACE) istio-injection=enabled
	
	@helm install scl-project --generate-name --namespace $(KUBERNETES_NAMESPACE)

.PHONY: clear
clear:			## Clear Kubernetes config & Docker images
	@echo "Delete namespace $(KUBERNETES_NAMESPACE)"
	@kubectl delete namespace $(KUBERNETES_NAMESPACE)

.PHONY: run
run:			## Run the application
	@echo "Running the application"
	minikube tunnel

.PHONY: helm-install
helm-install:		## Install and run the application with Helm
	@echo "Adding repo"
	@helm repo add st2scl-project https://AbdullatifGhajar.github.io/st2scl-project
	@helm repo update
	
	@echo "Installing the application in namespace $(KUBERNETES_NAMESPACE)"
	@helm install scl-project st2scl-project/scl-project --namespace $(KUBERNETES_NAMESPACE)

.PHONY: help
help:            	## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep
