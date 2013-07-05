#!/bin/bash

VHOSTS_DIR="/var/www"
ARCHIVES_DIR="~"

DESTINATION_HOST=""
DESTINATION_PORT="22"
DESTINATION_USER="root"
DESTINATION_DIR="/var/www"
DESTINATION_SUBDIR=""

#PLESK-STYLE
#DESTINATION_DIR="/var/www/vhosts"
#DESTINATION_SUBDIR="private/"


cd $ARCHIVES_DIR
scp -P "$DESTINATION_PORT" hosts.txt "$DESTINATION_USER"@"$DESTINATION_HOST":$ARCHIVES_DIR/



for line in $(cat "hosts.txt")
do

	
	cd $VHOSTS_DIR
	tar czvf $ARCHIVES_DIR/$line.tar.gz $line
	cd $ARCHIVES_DIR
	echo $line " website compressed"
	scp -P "$DESTINATION_PORT" $line.tar.gz "$DESTINATION_USER"@"$DESTINATION_HOST":$DESTINATION_DIR/$line/$DESTINATION_SUBDIR
	echo $line " website backup transfer complete"
	rm -f $line.tar.gz
	
	
#	PLESK-STYLE
#
#	cd /var/www/vhosts/$line
#	tar czvf $ARCHIVES_DIR/$line.tar.gz httpdocs
#	cd $ARCHIVES_DIR
#	echo $line " httpdocs compressed"
#	scp -P "$DESTINATION_PORT" $line.tar.gz "$DESTINATION_USER"@"$DESTINATION_HOST":/var/www/vhosts/$line/private/
#	echo $line " httpdocs transfer complete"
#	rm -f $line.tar.gz
#	
#	cd $VHOSTS_DIR/$line
#	tar czvf $ARCHIVES_DIR/$line.subdomains.tar.gz subdomains
#	cd $ARCHIVES_DIR
#	echo $line " subdomains compressed"
#	scp -P "$DESTINATION_PORT" $line.subdomains.tar.gz "$DESTINATION_USER"@"$DESTINATION_HOST":$DESTINATION_DIR/$line/$DESTINATION_SUBDIR
#	echo $line " subdomains tranfer complete"
#	rm -f $line.subdomains.tar.gz
#	
#	cd $VHOSTS_DIR/$line
#	tar czvf $ARCHIVES_DIR/$line.private.tar.gz private
#	cd $ARCHIVES_DIR
#	echo $line " private compressed"
#	scp -P "$DESTINATION_PORT" $line.private.tar.gz "$DESTINATION_USER"@"$DESTINATION_HOST":$DESTINATION_DIR/$line/$DESTINATION_SUBDIR
#	echo $line " private transfer complete"
#	rm -f $line.private.tar.gz
#	
#	cd $VHOSTS_DIR/$line
#	tar czvf $ARCHIVES_DIR/$line.statistics.tar.gz statistics
#	cd $ARCHIVES_DIR
#	echo $line " logs compressed"
#	scp -P "$DESTINATION_PORT" $line.statistics.tar.gz "$DESTINATION_USER"@"$DESTINATION_HOST":$DESTINATION_DIR/$line/$DESTINATION_SUBDIR
#	echo $line " logs transfer complete"
#	rm -f $line.statistics.tar.gz

done




