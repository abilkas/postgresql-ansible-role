#!/bin/bash

# Location to place backups.
backup_dir="{{ pg_backup_dir }}"

#String to append to the name of the backup files
backup_date=`date +%H-%M-%d-%m-%Y`

#Numbers of days you want to keep copie of your databases
number_of_days="{{ pg_rotation_days }}"

databases=`psql -l -t | cut -d'|' -f1 | grep -v postgres | grep -v template* | sed -e 's/ //g' -e '/^$/d'`
for i in $databases; do
    echo Dumping $i to $backup_dir/$i\_$backup_date.sql
    pg_dump $i > $backup_dir/$i\_$backup_date.sql
    bzip2  $backup_dir/$i\_$backup_date.sql
done

#rotation
find $backup_dir -type f -prune -mtime +$number_of_days -exec rm -f {} \;