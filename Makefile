.ONESHELL:
VENV_NAME=backend/env
VENV=$(VENV_NAME)/bin/

.PHONY: setup
setup: 				## Create environment and install base packages
	@echo "Creating an virtual env for python"
	@python3 -m venv $(VENV_NAME)
	@$(VENV)pip3 install black isort pycln flake8 pyproject-flake8 pytest

.PHONY: install-requirements
install-requirements:		## Install and update requirements
	@echo "Installing requirements"
	@$(VENV)pip3 install -r requirements.txt

.PHONY: help
help:            		## Show the help
	@echo "TARGETS\n"
	@fgrep "##" Makefile | fgrep -v fgrep