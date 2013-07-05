#!/bin/bash

#CONFIG
HOSTING_DIR="/var/www"

DESTINATION_HOST=""
DESTINATION_PORT="22"
DESTINATION_USER="root"
MYSQL_DB=""
MYSQL_USR=""
MYSQL_PWD=""

#BACKUP FILES
echo "Creating $HOSTING_DIR archive..."
tar czf "$HOSTING_DIR".tar.gz "$HOSTING_DIR"
#COPY FILES
echo "Copy $HOSTING_DIR archive to destination host..."
scp -P "$DESTINATION_PORT" "$HOSTING_DIR".tar.gz "$DESTINATION_USER"@"$DESTINATION_HOST":~/

#BACKUP DB
if [ "$MYSQL_DB" != "" ]
	then
	echo "Dumping database $MYSQL_DB"
	mysqldump -u"$MYSQL_USR" -p"$MYSQL_PWD" "$MYSQL_DB" > "$MYSQL_DB".sql
	echo "Copy database dump to destination host..."
	scp -P "$DESTINATION_PORT" "$MYSQL_DB".sql "$DESTINATION_USER"@"$DESTINATION_HOST":~/
fi

echo "All Done."
