KUBERNETES_NAMESPACE=scl-project

.PHONY: init
init:			## Start and initialize Kubernetes
	@echo "Starting Minikube"
	@minikube start --driver=docker --memory=2000 --cpus=2

	@echo "Setting up Istio (Servce Mesh)"
	@curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.20.0 sh -
	@mv istio-1.20.0 /tmp
	@/tmp/istio-1.20.0/bin/istioctl install --set profile=default -y

	@helm install scl-project st2scl-project/scl-project --namespace $(KUBERNETES_NAMESPACE) --create-namespace
	@kubectl label namespace $(KUBERNETES_NAMESPACE) istio-injection=enabled

.PHONY: clear
clear:			## Clear project
	@echo "Delete Helm chart in namespace $(KUBERNETES_NAMESPACE)"
	@helm uninstall scl-project --namespace $(KUBERNETES_NAMESPACE)

.PHONY: run
run:			## Run the application
	@echo "Running the application"
	minikube tunnel

.PHONY: install-helm
install-helm:		## Install Helm & Add repo
	@echo "Installing Helm"
	@curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	@chmod 700 get_helm.sh
	@mv get_helm.sh /tmp/get_helm.sh
	@/tmp/get_helm.sh
	
	@echo "Adding repo"
	@helm repo add st2scl-project https://AbdullatifGhajar.github.io/st2scl-project
	@helm repo update

.PHONY: help
help:            	## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep
