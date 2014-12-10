#!/bin/bash

CURRENT_IP=""
LAST_IP=""

function notify () {
  osascript -e "display notification \"$1\" with title \"Connection Monitor\""
}

function getISP () {
  curl -s http://www.telize.com/geoip | python -mjson.tool | grep isp | awk -F':' '{ print $2 }' | sed 's/ \"//g' | sed 's/",//g'
}

while [ 1 ] ; do

  CURRENT_IP=`curl -s icanhazip.com`

  if [ "$CURRENT_IP" == "" ] ; then
    notify "Internet connection lost."

  elif [ "$LAST_IP" == "" ] ; then
    ISP=$(getISP)
    notify "New IP: $CURRENT_IP\nISP: $ISP"

  elif [ "$LAST_IP" != "$CURRENT_IP" ] ; then
    ISP=$(getISP)
    notify "$LAST_IP > $CURRENT_IP \nISP: $ISP"

  fi

  LAST_IP=$CURRENT_IP

  sleep 60

done
