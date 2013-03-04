#!/bin/bash
# Gestione emergenze su Plesk VPS
# Configura ed esegui questo script per raccogliere automaticamente dati di log utili per rilevare attacchi sul VPS


# Configurazione - lasciare vuoto se non si hanno dati sufficienti
REDALERTDIR="redalert"
SUMMARIESDIR="summary"
IPSOSPETTO=""
MAILSOSPETTA=""
DATASOSPETTA=""


rm -rf $REDALERTDIR
mkdir $REDALERTDIR
mkdir $REDALERTDIR/$SUMMARIESDIR


######### HTTPD

# Uso disco dei file di log di tutti i domini
du -h /var/www/vhosts/ --max-depth 3 |grep -i "logs" > ./$REDALERTDIR/$SUMMARIESDIR/domain_logs_disk_usage.redalert.log

# Errori httpd
cat /var/log/httpd/error_log |grep -i "error" |grep -i "$DATASOSPETTA" |grep -i "$IPSOSPETTO" > ./$REDALERTDIR/httpd_errors.redalert.txt

# Accessi httpd
cat /var/log/httpd/access_log |grep -i "$DATASOSPETTA" |grep -i "$IPSOSPETTO" > ./$REDALERTDIR/httpd_access.redalert.txt

######### MYSQL

# Errori mysql
cat /var/log/mysqld.log |grep -i "ERROR" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/mysql_errors.redalert.txt


######### SSH

# Tentativi di accesso ssh falliti
cat /var/log/secure |grep -i "Failed password" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/failed_intrusion_detection.redalert.txt

# Accessi ssh effettuati - tutti
cat /var/log/secure |grep -i "Accepted password" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/successful_ssh_logins.redalert.txt

# Accessi ssh effettuati da ip sospetto
cat /var/log/secure |grep -i "Accepted password" |grep -i "$IPSOSPETTO" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/successful_intrusion_detection.redalert.txt


######### PROFTPD

# Tentativi di accesso proftpd 
cat /var/log/secure |grep -i "ftp" > ./$REDALERTDIR/proftpd.redalert.txt

# Accessi riusciti proftpd
cat /var/log/secure |grep -i "ftp" |grep -i "Login successful" > ./$REDALERTDIR/successful_proftpd.redalert.txt

# Accessi riusciti proftpd da ip sospetto
cat /var/log/secure |grep -i "ftp" |grep -i "Login successful" |grep -i "$IPSOSPETTO" > ./$REDALERTDIR/successful_intrusion_proftpd.redalert.txt


######### ACCESSI WEBMAIL

# Accessi webmail falliti
cat /var/log/psa-horde/psa-horde.log |grep -i "FAILED LOGIN" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/failed_webmail_access.redalert.txt

# Accessi webmail da ip sospetto
cat /var/log/psa-horde/psa-horde.log |grep -i "$IPSOSPETTO" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/webmail_IPSOSPETTO.redalert.txt

# Accessi webmail relativi ad indirizzo sospetto
cat /var/log/psa-horde/psa-horde.log |grep -i "$MAILSOSPETTA" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/webmail_MAILSOSPETTA.redalert.txt


######### MAIL LOG

# Log qmail
cat /usr/local/psa/var/log/maillog |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/maillog.redalert.txt

# Log qmail processate
cat /usr/local/psa/var/log/maillog.processed |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/maillog.processed.redalert.txt

######### REPORTS SUMMARIES

# Filtro tutto e faccio i sommari dei dati estrapolati
for file in $REDALERTDIR/*.redalert.txt
do
	echo "########## $file ##########" >> ./$REDALERTDIR/$SUMMARIESDIR/IPSOSPETTO.redalert.log
	cat $file | grep -i "$IPSOSPETTO" >> ./$REDALERTDIR/$SUMMARIESDIR/IPSOSPETTO.redalert.log
	
	echo "########## $file ##########" >> ./$REDALERTDIR/$SUMMARIESDIR/MAILSOSPETTA.redalert.log
	cat $file | grep -i "$MAILSOSPETTA" >> ./$REDALERTDIR/$SUMMARIESDIR/MAILSOSPETTA.redalert.log
done

# netstat con nomi host
netstat -a --tcp --udp > ./$REDALERTDIR/$SUMMARIESDIR/netstat_hosts.redalert.log

# netstat con indirizzi numerici
netstat -an --tcp --udp > ./$REDALERTDIR/$SUMMARIESDIR/netstat_numeric.redalert.log

######### MODIFIED FILES

# files in /var/www/vhosts modificati negli ultimi 30 giorni
find /var/www/vhosts/ -mtime -30 > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.month.all.txt

# files in /var/www/vhosts modificati nell'ultima settimana
find /var/www/vhosts/ -mtime > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.week.all.txt

# files in /var/www/vhosts modificati nell'ultimo giorno
find /var/www/vhosts/ -mtime > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.day.all.txt



# *.php modificati negli ultimi 30 giorni
find /var/www/vhosts/ -mtime -30 -name "*.php" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.month.php.txt

# *.php modificati nell'ultima settimana
find /var/www/vhosts/ -mtime -7 -name "*.php" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.week.php.txt

# *.php modificati nell'ultimo giorno
find /var/www/vhosts/ -mtime -1 -name "*.php" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.day.php.txt



# *.js modificati negli ultimi 30 giorni
find /var/www/vhosts/ -mtime -30 -name "*.js" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.month.php.txt

# *.js modificati nell'ultima settimana
find /var/www/vhosts/ -mtime -7 -name "*.js" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.week.php.txt

# *.js modificati nell'ultimo giorno
find /var/www/vhosts/ -mtime -1 -name "*.js" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.day.php.txt


chmod -R 777 $REDALERTDIR
