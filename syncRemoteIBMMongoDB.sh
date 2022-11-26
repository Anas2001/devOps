#!/bin/bash

TMPDIR=/tmp/mongodb_collections

function cleanup {
    echo "Cleaning up..."
    if [ -z ${TMPDIR+x} ] ; then
        echo -n
    else
        rm -rf $TMPDIR
    fi
    
    unset TMPDIR
    unset MONGO_SSL_DIR
    unset MONGO_REMOTE_USER
    unset MONGO_REMOTE_PASSWORD
    unset MONGO_REMOTE_CLUSTER
    unset MONGO_REMOTE_DB
    unset MONGO_LOCAL_DB
    unset MONGO_LOCAL_HOST
    unset MONGO_LOCAL_EVAL
}

MONGO_SSL_DIR=????
MONGO_REMOTE_USER=???
MONGO_REMOTE_PASSWORD=???????
MONGO_REMOTE_CLUSTER=?????????
MONGO_REMOTE_DB=??????

collection_list=(users party media comments invites packets promos shoppingcarts usernotifications customers)

mkdir -p "$TMPDIR"
rm -rf "$TMPDIR/$MONGO_REMOTE_DB"
echo "Dumping Remote DB to $TMPDIR... "
for collection in "${collection_list[@]}"; do
  echo "Dumping collection $collection .."
  mongodump -h "$MONGO_REMOTE_CLUSTER" -u "$MONGO_REMOTE_USER" -p "$MONGO_REMOTE_PASSWORD" --authenticationDatabase admin -d "$MONGO_REMOTE_DB" --collection "$collection" --ssl --sslCAFile "$MONGO_SSL_DIR" -o $TMPDIR
done

MONGO_LOCAL_DB="$MONGO_REMOTE_DB"
MONGO_LOCAL_HOST="localhost:27017,localhost:27018,localhost:27019"
echo "Overwriting Local DB with Dump $TMPDIR... "
MONGO_LOCAL_EVAL="db.dropDatabase();"
mongo "mongodb://$MONGO_LOCAL_HOST/$MONGO_LOCAL_DB?replicaSet=rs0" --eval "$MONGO_LOCAL_EVAL"
mongorestore --uri="mongodb://$MONGO_LOCAL_HOST/$MONGO_LOCAL_DB?replicaSet=rs0" $TMPDIR/$MONGO_REMOTE_DB

cleanup
