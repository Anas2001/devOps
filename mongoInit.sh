#!/bin/bash

if [ -z "${MONGO_PRIMARY-}" ]; then
   MONGO_PRIMARY=mongodb1:27017
fi

if [ -z "${MONGO_SECONDARY_ONE-}" ]; then
   MONGO_SECONDARY_ONE=mongodb2:27018
fi

if [ -z "${MONGO_SECONDARY_TWO-}" ]; then
   MONGO_SECONDARY_TWO=mongodb3:27019
fi

if [ -z "${MONGO_ADMIN_PASSWORD-}" ]; then
   MONGO_ADMIN_PASSWORD=verylooooongpasswordz
fi

mongo <<EOF
var config = {
    "_id": "rs0",
    "members": [{"_id":0,"host":"$MONGO_PRIMARY"},{"_id":1,"host":"$MONGO_SECONDARY_ONE"},{"_id":2,"host":"$MONGO_SECONDARY_TWO"}]
};
rs.initiate(config, { force: true });
db.createUser({user: 'admin', pwd: $MONGO_ADMIN_PASSWORD, roles: [ { role: 'root', db: 'admin' } ]});
EOF
