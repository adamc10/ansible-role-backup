#!/bin/bash
#
# $1 - source path
# $2 - destination path
# $3 - user database
# $4 - password for user database
# $5 - name database
# $6 -
#
date=$(date +%Y%m%d)
find $2 -type f -mtime +$6 -delete
cd $2
if [ $5 ]
then
  if [ $4 ]
  then
          nice -n 19 mysqldump -u$3 -p$4 --lock-tables=false --default-character-set=utf8 $5 | gzip > $2/$5_${date}.sql.gz
  else
          nice -n 19 mysqldump -u$3 --lock-tables=false --default-character-set=utf8 $5 | gzip > $2/$5_${date}.sql.gz
  fi
fi
nice -n 19 tar cvzf $2/backup_${date}.tar.gz -X $2'/../../bin/exclude.txt' $1 > /dev/null

data_info_file=$(stat /tmp/backup_info |grep -e Modify -e Модифицирован | awk '{print $2}' 2>/dev/null)
if [ `test -f /tmp/backup_info && echo "yes"` ]
then
        if [ "$data_info_file" != `date +%Y-%m-%d` ]
        then
                echo "$1 $date" > /tmp/backup_info
        else
                echo "$1 $date" >> /tmp/backup_info
        fi
else
        echo "$1 $date" > /tmp/backup_info
fi
