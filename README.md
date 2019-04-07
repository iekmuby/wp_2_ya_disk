# wp_2_ya_disk
EN
Wordpress backup to Yandex.Disk shell script

Change YA_USER and YA_PASS credentials first. Install WP-Cli.

Script create folder with current week name and subfolders FILES and DB.

Supports 3 args:
* files - search and upload as archive current day files from wp-content/uploads
* fullbackup -  upload as archive whole wp-content/uploads folder
* db - upload as archive current db dump

Usage
Run files and db backup every day. Fullbackup weekly on monday morning

0 1 * * * cd /YOUR_ROOT_PATH/ && sh backup.sh files db
0 0 * * 0 cd /YOUR_ROOT_PATH/ && sh backup.sh fullbackup


RU
Shell для архивирования данных Wordpress на Яндекс.Диск

Смените YA_USER и YA_PASS на логин и пароль к аккаунту Яндекс. Установите WP-Cli.

Скрипт создает папку с номером текущей недели и подпапки FILES и DB.

Поддерживает 3 агрумента:
* files - ищет и загружает все файлы созданные сегодня в папке wp-content/uploads в виде архива
* fullbackup -  загружает все файлы из wp-content/uploads в виде архива
* db - загружает дамп базы данных за сегодня в виде архива

Использование
Запускайте аршументы files и db каждый день. Fullbackup раз в неделю в понедельник утром

0 1 * * * cd /ПУТЬ_К_КОРНЕВОЙ_ДИРЕКТОРИИ/ && sh backup.sh files db
0 0 * * 0 cd /ПУТЬ_К_КОРНЕВОЙ_ДИРЕКТОРИИ/ && sh backup.sh fullbackup
