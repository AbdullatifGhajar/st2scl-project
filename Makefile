include .env

.ONESHELL:
VENV_NAME=backend/env
VENV=$(VENV_NAME)/bin/

FLASK_APP=backend/api.py

.PHONY: setup
setup: 				## Create environment and install base packages
	@echo "Creating an virtual env for python"
	@python3 -m venv $(VENV_NAME)
	@$(VENV)pip3 install black isort pycln flake8 pyproject-flake8 pytest

.PHONY: install-requirements
install-requirements:		## Install and update requirements
	@echo "Installing requirements"
	@sudo apt-get install libpq-dev python3.10-dev
	@$(VENV)pip3 install -r requirements.txt

.PHONY: run-db
run-db:				## Run Postgres database
	@echo "Running Postgres database"
	@docker-compose up -d

.PHONY: stop-db
stop-db:			## Stop Postgres database
	@echo "Stopping Postgres database"
	@docker-compose down

.PHONY: init-db
init-db: run-db			## initialize and run Postgres database
	@echo "Initilizing Postgres database"
	@sleep 1

	@$(VENV)python3 -m flask --app $(FLASK_APP) db init
	@$(VENV)python3 -m flask --app $(FLASK_APP) db migrate -m "initial migration"
	@$(VENV)python3 -m flask --app $(FLASK_APP) db upgrade

	@$(VENV)python3 -m backend

	@rm -r migrations
	
.PHONY: bash-db
bash-db:			## Run bash in Postgres database
	@echo "Running bash in Postgres database"
	@echo "Use 👉 psql -U postgres -d messenger_db" 
	@docker exec -it $(DB_CONTAINER_NAME) bash

.PHONY: help
help:            		## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep