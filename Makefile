include .env

.ONESHELL:
VENV_NAME=backend/env
VENV=$(VENV_NAME)/bin/

FLASK_APP=backend/app/app.py

.PHONY: setup
setup: 				## Create environment and install base packages
	@echo "Creating an virtual env for python"
	@python3 -m venv $(VENV_NAME)
	@$(VENV)pip3 install black isort pycln flake8 pyproject-flake8 pytest

.PHONY: install-requirements
install-requirements:		## Install and update requirements
	@echo "Installing requirements"
	@sudo apt-get install libpq-dev python3.10-dev
	@$(VENV)pip3 install -r backend/requirements.txt

.PHONY: run-db
run-db:				## Run Postgres database
	@echo "Running Postgres database"
	@docker compose up

.PHONY: stop-db
stop-db:			## Stop Postgres database
	@echo "Stopping Postgres database"
	@docker compose down

.PHONY: init-db
init-db: run-db			## initialize and run Postgres database
	@echo "Initilizing Postgres database"
	@sleep 1

	# add test data
	
.PHONY: bash-db
bash-db:			## Run bash in Postgres database
	@echo "Running bash in Postgres database"
	@echo "Use 👉 psql -U postgres -d messenger_db" 
	@docker exec -it $(DB_CONTAINER_NAME) bash

.PHONY: init-k8s
init-k8s:			## Start and initialize Kubernetes
	@echo "Starting Kubernetes"
	@minikube start --driver=docker

	@echo "Installing Ingress"
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
	@minikube addons enable ingress
	
	@echo "Applying Kubernetes config"
	@kubectl apply -f k8s
	@kubectl apply -f k8s/frontend
	@kubectl apply -f k8s/backend
	@kubectl apply -f k8s/database

.PHONY: clear-k8s
clear-k8s:			## Clear Kubernetes config
	@echo "Deleting deployments, services and pods"
	@kubectl delete deployment --all
	@kubectl delete statefulset --all
	@kubectl delete replicaset --all
	@kubectl delete daemonset --all
	@kubectl delete job --all
	@kubectl delete pods --all --all-namespaces

.PHONY: help
help:            		## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep