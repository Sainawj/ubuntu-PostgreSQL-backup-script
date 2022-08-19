#!/bin/bash

# Setup shell to use for backups
SHELL=/bin/bash

# Setup name of local server to be backed up
SERVER="servername"

# Setup event stamps
DOW=`date +%a`
TIME=`date`
DOW2=`date +%d-%m-%Y-%H:%M`

# Setup paths
FOLDER="/home/backup"
FILE="/var/log/backup-$DOW.log"

# Do the backups
{
echo "Backup started: $TIME"

# Make the backup folder if it does not exist
if test ! -d /home/backup
then
  mkdir -p /home/backup
  echo "New backup folder created"
  else
  echo ""
fi

# Make sure we're in / since backups are relative to that
cd /

## PostgreSQL database (Needs a /root/.pgpass file)
which -a psql
if [ $? == 0 ] ; then 
    echo "SQL dump of PostgreSQL databases"
    su - postgres -c "pg_dump --inserts dspace > /tmp/dspace-db.sql"
    # Copy the "dspace-db.sql" file from temporary folder to the created folder in "/home/backup"
    cp /tmp/dspace-db.sql $FOLDER/repositorydb-$DOW2.sql
    su - postgres -c "vacuumdb --analyze dspace > /dev/null 2>&1"
fi

# Delete old backup files
#echo "Delete old backup files"
find /home/backup/* -mtime +5 -exec rm {} \;

# Delete old log files
#Be careful some a lot of log files will consume alot of disk space, its adisable to delete files more than 30 days
#echo "Delete old log files"
find /home/dspace/log/* -mtime +30 -exec rem {} \;

#zip assetstore folder and store it in backup folder
zip -r /home/backup/assetstore-$DOW2.zip /home/dspace/assetstore

# Backup '/etc' folder 
#echo "Archive '/etc' folder"
#tar czf $FOLDER/etc-$DOW.tgz etc/

# Backup '/root' folder
#echo "Archive '/root' folder"
#tar czf $FOLDER/root.tgz root/

# Backup '/usr/local' folder
#echo "Archive '/usr/local' folder"
#tar czf $FOLDER/usr-local.tgz usr/local/

# View backup folder
echo ""
echo "** Backup folder **"
ls -lhS $FOLDER

# Show disk usage
echo ""
echo "** Disk usage **"
df -h

TIME=`date`
echo "Backup ended: $TIME"

} > $FILE

# This will send a mail to once backup is complete
cat $FILE | mail -s "Repository Backup : $DOW : $SERVER" sainawj@mail.domain

### EOF ###
