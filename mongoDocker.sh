#!/bin/bash

if [ -z "${MONGO_PORT-}" ]; then
  MONGO_PORT=27017
  export MONGO_PORT
fi

if [ -z "${MONGO_VERSION-}" ]; then
  MONGO_VERSION=5.0.9
  export MONGO_VERSION
fi

if [ -z "${MONGO_IP-}" ]; then
  MONGO_IP=127.0.0.1
  export MONGO_IP
fi

if [ -z "${MONGO_VERSION-}" ]; then
  MONGO_VERSION=5.0.9
  export MONGO_VERSION
fi

if [ -z "${MONGO_NAME-}" ]; then
  MONGO_NAME=mongodb1
  export MONGO_NAME
fi

curl https://raw.githubusercontent.com/Anas2001/devOps/main/mongoInit.sh -o docker.sh -o mongoInit.sh

docker run \
  -p $MONGO_IP:$MONGO_PORT:$MONGO_PORT \
  -v /var/lib/$MONGO_NAME:/data/db -v "$(pwd)/mongoInit.sh:/scripts/rs.sh" \
  --name $MONGO_NAME \
  -d --restart=always mongo:$MONGO_VERSION \
  mongod --replSet rs0 --port $MONGO_PORT 
  
  
