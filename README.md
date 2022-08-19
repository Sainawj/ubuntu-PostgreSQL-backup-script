# ubuntu-PostgreSQL-backup-script
Create a backup script for your postgresql server
Copy the script and paste it to this file
sudo nano /usr/local/bin/backup.sh
Remember to replace hostname and email address
Press CTL+O	= Save the file and then press Enter
Press CTL+X	= Exit "nano"
Make the script executable by typing $ sudo chmod 0755  /usr/local/bin/backup.sh
To check if backup directory created by the script contains the backup files type: $ sudo ls -lh /home/backup
You may set up daily backup every 6:00 am by:
Open crontab as root user: $ sudo crontab -e
Type: 00 5 * * * /usr/local/bin/backup.sh
Press CTL+O	= Save the file and then press Enter
Press CTL+X	= Exit "nano"
Done!!
