#!/bin/bash
# test_upload.sh using node to /home/ssandrew/3d_processor/IN_COMMING
#
#######################################################################

CSV=/home/ssandrew/3d_processor/process_list.csv
ID=20260313_SA_00003

if [ -r /tmp/curl.log ];then
  rm /tmp/curl.log
fi

node_check()
{
NODE_UP=`ps -ef | grep node | grep -v grep`
echo 
if [ "${NODE_UP}" != "" ];then
  echo "1) OK - NODE UP:"
  echo $NODE_UP
else 
  echo "1) ERROR: - NODE ps -ef | grep node not found!"
  echo $NODE_UP
fi
echo 
}

check_csv()
{
# 20260313_SA_00003,steven.scott.andrew@gmail.com,AVAILABLE,2026-03-19 14:29:07
F=/home/ssandrew/scripts/${ID}.txt
echo " ... CSV STATUS FOR: $F"
grep $ID $CSV
echo 
}

upload_test()
{

echo "2) CURL Upload test:  http://127.0.0.1:3000/survey/upload-survey "
curl -s -X POST -F "id=20260313_SA_00003" -F "file=@${F}" http://127.0.0.1:3000/survey/upload-survey -o /tmp/curl.log
OK=`ls -l $HOME/3d_processor/IN_BOUND/survey*20260313_SA_00003.txt`
if [ "${OK}" != "" ];then
   echo "OK: Upload worked, see ls -l below for $F upload"
   ls -l $HOME/3d_processor/IN_BOUND/survey*${ID}.txt
   echo "Removing ..."
   rm $HOME/3d_processor/IN_BOUND/survey*${ID}.txt
else
   echo "ERROR: Upload failed using:  http://127.0.0.1:3000/survey/upload-survey"
   cat /tmp/curl.log
   echo "Check node is running: ps -ef | grep node"
   ps -ef | grep node | grep -v grep
   node_check
fi
echo 
}


########
# MAIN #
########
node_check
check_csv
upload_test
echo 
echo "After Check Csv, and still in Available Status. (Only changes when processed each 5 minutes)"
check_csv
