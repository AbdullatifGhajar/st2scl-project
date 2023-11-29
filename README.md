# st2scl-project

Final Project for 'Software Engineering for the Cloud'

## Project Description

This project is a simple chat web application. When you run the app, you will be logged in as Bob and can have conversations with other users.

## How to Run

First make sure you have `Docker` and `Minikube` installed and `Kubernetes` activated on Docker.

First run `run init` to pull images from Docker Hub and create the Kubernetes cluster.

Then run `run start` to start the app.

The app will be available at `localhost`.

## Technologies Used

### Backend

- Flask (Python): REST API for chat messages (fetch and post)

### Frontend

- React (JavaScript): UI for chat messages

### Database

- PostgreSQL: Database for authors and messages

### Deployment

- Docker: every component (frontend, backend, database) is run in a Docker container published on Docker Hub
- Kubernetes

### CI

- Github Actions: CI pipeline for building and publishing Docker images. So pushing changes to main will trigger github to update the Docker images on Docker Hub.

## Architecture
