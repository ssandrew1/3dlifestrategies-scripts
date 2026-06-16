#!/bin/bash

D=`date +%Y-%m-%d.%H.%M`
cd /home/ssandrew

clearOld()
{
 for d in /home/ssandrew /tmp
 do
  echo "Clear old backups from: $d"
  rm ${d}/code_and_server_2026*.zip
  rm ${d}/web_3d_html_2026*.zip
 done
}

backCodeAndServers()
{
 echo 
 cp /etc/nginx/nginx.conf web_config/
 pr /etc/nginx/sites-enabled/* > web_config/sites_enabled.config
 echo "Starting Backup: $D"
 zip code_and_servers_${D}.zip mail_server/* mail_server/*/* web_config/* 3d_processor/* 3d_processor/DONE/*
 mv  code_and_servers_${D}.zip /tmp/
}

backHtml()
{ 
  WEB=/var/www/3dlifestrategies.org/html
  zip web_3d_html_${D}.zip $WEB/* $WEB/beta/*
  echo 
  echo "Backups Complete $D"
  echo "Validate 2 zips created: "
  ls -lrt | grep zip
  echo 
  echo "Copied to tmp for easier download"
  mv  web_3d_html_${D}.zip /tmp/
}

## MAIN BACKUP
clearOld
backCodeAndServers
backHtml
echo "Done: Backups are put in: /tmp/web_3d_html_${D}.zip and code_and_servers_${D}.zip"
