FROM python:3.10-slim

RUN apt-get update
RUN apt-get install build-essential libpq-dev -y