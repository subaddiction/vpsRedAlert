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
du -h /var/log/ --max-depth 3 > ./$REDALERTDIR/$SUMMARIESDIR/domain_logs_disk_usage.redalert.log

# Errori apache2
cat /var/log/apache2/error.log |grep -i "error" |grep -i "$DATASOSPETTA" |grep -i "$IPSOSPETTO" > ./$REDALERTDIR/apache2_errors.redalert.txt

# Accessi apache2
cat /var/log/apache2/access.log |grep -i "$DATASOSPETTA" |grep -i "$IPSOSPETTO" > ./$REDALERTDIR/apache2_access.redalert.txt
cat /var/log/apache2/other_vhosts_access.log |grep -i "$DATASOSPETTA" |grep -i "$IPSOSPETTO" > ./$REDALERTDIR/apache2_other_vhosts_access.redalert.txt

# Sql injections


######### MYSQL

# Errori mysql
cat /var/log/mysql.err |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/mysql_errors.redalert.txt

# Logs mysql
cat /var/log/mysql.log |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/mysql_logs.redalert.txt


######### SSH

# Tentativi di accesso ssh falliti
cat /var/log/auth.log |grep -i "Failed password" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/failed_intrusion_detection.redalert.txt

# Accessi ssh effettuati - tutti
cat /var/log/auth.log |grep -i "Accepted password" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/successful_ssh_logins.redalert.txt

# Accessi ssh effettuati da ip sospetto
cat /var/log/auth.log |grep -i "Accepted password" |grep -i "$IPSOSPETTO" |grep -i "$DATASOSPETTA" > ./$REDALERTDIR/successful_intrusion_detection.redalert.txt


######### MAIL TASKS

# Accessi webmail falliti
cat /var/log/mail.err |grep -i "$IPSOSPETTO" |grep -i "$DATASOSPETTA" |grep -i "$MAILSOSPETTA" > ./$REDALERTDIR/mail_error.redalert.txt

# Accessi webmail da ip sospetto
cat /var/log/mail.warn |grep -i "$IPSOSPETTO" |grep -i "$DATASOSPETTA" |grep -i "$MAILSOSPETTA" > ./$REDALERTDIR/mail_warning.redalert.txt

# Accessi webmail relativi ad indirizzo sospetto
cat /var/log/mail.log |grep -i "$IPSOSPETTO" |grep -i "$DATASOSPETTA" |grep -i "$MAILSOSPETTA" > ./$REDALERTDIR/mail_log.redalert.txt


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
netstat -ap --tcp --udp > ./$REDALERTDIR/$SUMMARIESDIR/netstat_hosts.redalert.log

# netstat con indirizzi numerici
netstat -anp --tcp --udp > ./$REDALERTDIR/$SUMMARIESDIR/netstat_numeric.redalert.log

# processi in esecuzione in formato human-readable
ps -e u > ./$REDALERTDIR/$SUMMARIESDIR/processes.redalert.log

######### MODIFIED FILES

# files in /var/www modificati negli ultimi 30 giorni
find /var/www -mtime -30 > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.month.all.txt

# files in /var/www modificati nell'ultima settimana
find /var/www -mtime -7 > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.week.all.txt

# files in /var/www modificati nell'ultimo giorno
find /var/www -mtime -1 > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.day.all.txt



# *.php modificati negli ultimi 30 giorni
find /var/www/ -mtime -30 -name "*.php" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.month.php.txt

# *.php modificati nell'ultima settimana
find /var/www/ -mtime -7 -name "*.php" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.week.php.txt

# *.php modificati nell'ultimo giorno
find /var/www/ -mtime -1 -name "*.php" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.day.php.txt



# *.js modificati negli ultimi 30 giorni
find /var/www -mtime -30 -name "*.js" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.month.php.txt

# *.js modificati nell'ultima settimana
find /var/www -mtime -7 -name "*.js" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.week.php.txt

# *.js modificati nell'ultimo giorno
find /var/www -mtime -1 -name "*.js" > ./$REDALERTDIR/$SUMMARIESDIR/modified.last.day.php.txt

chmod -R 777 $REDALERTDIR
