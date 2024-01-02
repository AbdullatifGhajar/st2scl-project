# st2scl-project

Final Project for 'Software Engineering for the Cloud'

## Project Description

This project is a simple chat web application. When you run the app, you will be logged in as Bob and can have conversations with other users.

## How to Run

First run `make install-helm`, then `make init` and finally `make run`.

The app will be available at `localhost`.

## Technologies Used

### Backend

- Flask (Python): REST API for chat messages (fetch and post). The API is available at `localhost/api/`.

### Frontend

- React (JavaScript): UI for chat messages based on Javascript. The UI is available at `localhost`.

### Database

- PostgreSQL: Database for authors and messages. Could be extended for authentication.

### Deployment

- Docker: every component (frontend, backend, database) is a Docker container published on Docker Hub.
- Kubernetes: every component is deployed as a Kubernetes service in it's own pod. In an early version I used ingress as a gateway, but later switched to a service mesh, so you'll find virtual services too.
- Service Mesh: defines a gateway for the frontend and backend services. The gateway forwards all paths starting with `\api` to the backend service and all other paths to the frontend service.
- Helm: the whole project is a Helm chart published on Github Pages. So you can install the project with `helm install st2scl-project st2scl-project/st2scl-project`, which is included in the Makefile.

### CI

- Github Actions: CI pipeline for building and publishing Docker images. So pushing changes to main will trigger github to update the Docker images on Docker Hub.
