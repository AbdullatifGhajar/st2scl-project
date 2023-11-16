FROM python:3.10-slim AS cached

RUN apt-get update
RUN apt-get install build-essential libpq-dev -y 

FROM cached as builder

COPY app /app
WORKDIR /app

COPY requirements.txt /app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

COPY entrypoint.sh /app

ENTRYPOINT ["./entrypoint.sh"]

FROM builder as dev-envs

RUN <<EOF
apk update
apk add git
EOF

RUN <<EOF
addgroup -S docker
adduser -S --shell /bin/bash --ingroup docker vscode
EOF
# install Docker tools (cli, buildx, compose)
COPY --from=gloursdocker/docker / /