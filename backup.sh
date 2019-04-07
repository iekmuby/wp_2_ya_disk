#!/bin/bash

#Yandex disk credentials
YA_USER="Yandex USERNAME";
YA_PASS="Yandex PASS";
YA_FILES_FOLDER="files";
YA_DB_FOLDER="db";

NOW=$(date +"%Y-%m-%d")
WEEKNUM=$(date -d "now" +%V)
PREVWEEKNUM=$(date -d "now -2 week" +%V) #Remove folder older than 2 weeks
BACKUP_FILE="backup.$NOW"
ROOT_DIR=$PWD;

mkdir -p backups/$YA_FILES_FOLDER
mkdir -p backups/$YA_DB_FOLDER

#Creating current week folder structure
curl --user $YA_USER:$YA_PASS -X MKCOL https://webdav.yandex.ru/$WEEKNUM/
curl --user $YA_USER:$YA_PASS -X MKCOL https://webdav.yandex.ru/$WEEKNUM/$YA_FILES_FOLDER
curl --user $YA_USER:$YA_PASS -X MKCOL https://webdav.yandex.ru/$WEEKNUM/$YA_DB_FOLDER

cd $ROOT_DIR;

for n in $@
do
    #Backing up database
	if [ $n = "db" ]; then
		echo "Backing up database";
		cd $ROOT_DIR;
		cd backups/db/

		wp db export $BACKUP_FILE".db.sql" --add-drop-table --allow-root
		tar rvf  $BACKUP_FILE".db.sql.tar" $BACKUP_FILE".db.sql"
		rm $BACKUP_FILE".db.sql"
		gzip -9 $BACKUP_FILE".db.sql.tar"
		curl --user $YA_USER:$YA_PASS -T $BACKUP_FILE".db.sql.tar.gz" https://webdav.yandex.ru/$WEEKNUM/$YA_DB_FOLDER/
		rm $BACKUP_FILE".db.sql.tar.gz"
	fi

    #Backing up uploads
	if [ $n = "files" ]; then
		echo "Backing up files";
		cd $ROOT_DIR;
		files=$(find wp-content/uploads/ -type f -mtime 0)
		lines=$(find wp-content/uploads/ -type f -mtime 0 | wc -l)

		if [ $lines -gt 0 ]; then
			for files in ${files[*]}
				do
					tar rvf backups/files/$BACKUP_FILE".files.tar" $files
				done
			gzip -9 backups/files/$BACKUP_FILE".files.tar"
			curl --user $YA_USER:$YA_PASS -T backups/files/$BACKUP_FILE".files.tar.gz" https://webdav.yandex.ru/$WEEKNUM/$YA_FILES_FOLDER/
			rm backups/files/$BACKUP_FILE".files.tar.gz"

		fi
	fi

    #Backing up whole uploads directory and removing previous data
    if [ $n = "fullbackup" ]; then
        cd $ROOT_DIR
		tar -zcvf backups/$BACKUP_FILE".full.tar.gz" wp-content/uploads
		curl --user $YA_USER:$YA_PASS -T backups/$BACKUP_FILE".full.tar.gz" https://webdav.yandex.ru/$WEEKNUM/$YA_FILES_FOLDER/
		rm backups/$BACKUP_FILE"full.tar.gz"
		curl --user $YA_USER:$YA_PASS -X DELETE https://webdav.yandex.ru/$PREVWEEKNUM/
    fi

done
