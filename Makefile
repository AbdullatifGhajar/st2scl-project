.ONESHELL:
VENV_NAME=backend/env
VENV=$(VENV_NAME)/bin/

ENV_FILE=.env

FLASK_APP=backend/api.py

DB_DOCKER_IMAGE=postgres_image
DB_DOCKER_CONTAINER=postgres_container

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

.PHONY: init-db
init-db:		## initialize and run Postgres database
	@echo "Running Postgres database"
	@docker build -t $(DB_DOCKER_IMAGE) database/
	@docker run --name $(DB_DOCKER_CONTAINER) -d -p 5432:5432 --env-file $(ENV_FILE) $(DB_DOCKER_IMAGE)

.PHONY: bash-db
bash-db:		## Run bash in Postgres database
	@echo "Running bash in Postgres database"
	@docker exec -it $(DB_DOCKER_CONTAINER) bash
.PHONY: help
help:            		## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep