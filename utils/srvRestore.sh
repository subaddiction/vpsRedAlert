#!/bin/bash

BACKUPS_DIR="/var/www"
BACKUPS_SUBDIR=""

VHOSTS_DIR="/var/www"
WEBSERVER_USER="www-data"

#PLESK-STYLE
#BACKUPS_DIR="/var/www/vhosts"
#BACKUPS_SUBDIR="private/"
#VHOSTS_DIR="/var/www/vhosts"
#WEBSERVER_USER="psaserv"

for line in $(cat hosts.txt)
do
	
	OWNER=$(stat -c %U $VHOSTS_DIR/$line)
	
	cd $BACKUPS_DIR/$line/$BACKUPS_SUBDIR
	chmod 700 $line.tar.gz
	mv $line.tar.gz $VHOSTS_DIR
	cd $VHOSTS_DIR
	tar xzvf $line.tar.gz


#	PLESK-STYLE
#	cd $VHOSTS_DIR/$line
#	
#	OWNER=$(stat -c %U /var/www/vhosts/$line/httpdocs)
#	
#	mv $BACKUPS_SUBDIR/$line.private.tar.gz $BACKUPS_SUBDIR/$line.old_private.tar.gz
#	chown -R $OWNER:root $BACKUPS_SUBDIR
#	
#	tar xzvf $BACKUPS_SUBDIR/$line.tar.gz
#	chown -R $OWNER:$WEBSERVER_USER httpdocs
#	rm -f $BACKUPS_SUBDIR/$line.tar.gz
#	
#	tar xzvf $BACKUPS_SUBDIR/$line.subdomains.tar.gz
#	chown -R $OWNER:$WEBSERVER_USER subdomains
#	rm -f $BACKUPS_SUBDIR/$line.subdomains.tar.gz
#	
#	tar xzvf $BACKUPS_SUBDIR/$line.statistics.tar.gz
#	chown -R $OWNER:$WEBSERVER_USER statistics
#	rm -f $BACKUPS_SUBDIR/$line.statistics.tar.gz
	
	
done
