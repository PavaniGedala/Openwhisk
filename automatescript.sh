#!/bin/bash

function usage() {
  echo "Usage: $0 [--install,--uninstall,--env]"
}

function install() {
    wsk package bind /whisk.system/cloudant /serverlessworks_serverlessworks/bluemixcloudant  -p host $CLOUDANT_host -p username $CLOUDANT_username -p password $CLOUDANT_password -p dbname $CLOUDANT_dbname
	echo "creating an action"
	wsk action create createdoc create.js
	echo "creating an action"
	wsk action create readdoc read.js
	echo "creating seq actions"
    wsk action create createseq --sequence createdoc,bluemixcloudant/write
	echo "creating seq actions"
    wsk action create readseq --sequence readdoc,bluemixcloudant/read
    
}

function uninstall() {
  echo "Removing actions..."
  wsk action delete createdoc
  wsk action delete readdoc
  wsk action delete createSeq
  wsk action delete readSeq
  echo "Removing packages..."
  wsk package delete bluemixcloudantdetails
  echo "Done"
  wsk list
}

function showenv() {
  echo CLOUDANT_username=$CLOUDANT_username
  echo CLOUDANT_password=$CLOUDANT_password
  echo CLOUDANT_host=$CLOUDANT_host
  echo CLOUDANT_dbname=$CLOUDANT_dbname
 
}

case "$1" in
"--install" )
install
;;
"--uninstall" )
uninstall
;;
"--update" )
update
;;
"--env" )
showenv
;;
"--disable" )
disable
;;
"--enable" )
enable
;;
"--recycle" )
uninstall
install
;;
* )
usage
;;
esac
