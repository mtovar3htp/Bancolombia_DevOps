#!/bin/bash
####
# Script: Execute an app, and verify the request status
###

#Pass arguments
USER=$1
PSSWD=$2
URL=$3
JSON_FILE=$4
#
#REQUEST_STATE="PENDING"
REQ_RESULT=" "
cd /opt/ibm-ucd/udclient

if [[ "$USER" != "" && "PSSWD" != "" && "URL" != "" && "$JSON_FILE" != "" ]]; then

 idrequest=$(./udclient -username $USER -password $PSSWD -weburl $URL requestApplicationProcess $JSON_FILE | cut -d " " -f 2 | tr -d '"' | tr -d '}')
 echo $idrequest

 if [[ "$idrequest" == *Retry* ]]; then
  echo "Error: invalid arguments"
  exit 1
 else
   while [ "$REQUEST_STATE" != "CLOSED" ]
   do
   REQUEST_STATE=$(./udclient -username $USER -password $PSSWD -weburl $URL getApplicationProcessRequestStatus -request $idrequest | tr -d '\n'| tr -d '{' | tr -d '}' | tr -d '"' | tr -d ':' | tr -d ',' | sed 's/  //' | sed 's/  / /' | cut -d ' ' -f 2)
   sleep 7
   echo "working..."
   done
 fi
