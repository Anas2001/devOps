#!/bin/bash

if [ -z "${MONGO_USER_NAME-}" ]; then
   MONGO_USER_NAME=user
fi

if [ -z "${MONGO_USER_PASSWORD-}" ]; then
   MONGO_USER_PASSWORD=verylooooongpasswordz
fi

if [ -z "${MONGO_DATABASE-}" ]; then
   MONGO_APP_DATABASE=app-data
fi

if [ -z "${MONGO_DATABASE-}" ]; then
   MONGO_DATABASE_ROLE=readWrite
fi

if [ -z "${MONGO_PORT-}" ]; then
   MONGO_PORT=27017
fi

mongo --port $MONGO_PORT -u "amin" -p $MONGO_ADMIN_PASSWORD <<EOF
  db.createUser({user: $MONGO_USER_NAME, pwd: $MONGO_USER_PASSWORD, roles: [ { role: $MONGO_DATABASE_ROLE, db: $MONGO_DATABASE } ]});
EOF
