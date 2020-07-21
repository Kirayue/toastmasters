#!/bin/bash
set -e
DIR=$(echo $(cd $(dirname ${BASH_SOURCE[0]})/.. && pwd))

docker build -t local/nginx -f ./docker/nginx.Dockerfile ./src/nginx
docker build -t local/h1 -f ./docker/backend.Dockerfile ./src/backend

{ 
  docker swarm init 2> /dev/null 
} || { 
  echo 'swarm mode is already init.' 
}

docker-compose -f ${DIR}/docker-compose/docker-compose.yaml up -d
docker stack deploy -c ./docker-compose/docker-compose.yaml demo
