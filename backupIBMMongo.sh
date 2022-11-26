#!/bin/bash

TMPDIR=/tmp/mongodb_collections

DESTINATION_PATH=.

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
    unset MONGO_ZIP_FILE_NAME
    unset DESTINATION_PATH
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

MONGO_ZIP_FILE_NAME="test-$(date +"%d.%m.%Y-%H:%M:%S").zip"

zip -r "$DESTINATION_PATH/$MONGO_ZIP_FILE_NAME" "$TMPDIR/$MONGO_REMOTE_DB"

# Remove old backups 
MAX_NUMBER_OF_FILES=11 #max files in DESTINATION_PATH 10
ls -ut1 "$DESTINATION_PATH" | tail -n+"$MAX_NUMBER_OF_FILES" > /tmp/files_to_removed$$
if [[ `cat /tmp/files_to_removed$$ | wc -l` -ge "$MAX_NUMBER_OF_FILES" ]] ; then
  while read line ; do
    rm -rf "$DESTINATION_PATH/$line"
  done < /tmp/files_to_removed$$
fi
rm -rf /tmp/files_to_removed$$




