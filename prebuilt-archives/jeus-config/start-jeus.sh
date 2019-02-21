#!/bin/bash

set -e

source /home/vcap/app/.profile


CONTAINER_HOSTNAME=`hostname -f`

echo "updating jeus configuration for container: $CONTAINER_HOSTNAME"


if [ -f "$JEUS_HOME/config/vhost.properties" ]; then
  echo "updating  hostname in $JEUS_HOME/config/vhost.properties"
  sed -i "s/__CONTAINER_HOSTNAME__/$CONTAINER_HOSTNAME/g" "$JEUS_HOME/config/vhost.properties"
  sed -i "s/jeus.vhost.enabled=true/jeus.vhost.enabled=false/g" "$JEUS_HOME/config/vhost.properties"
  
fi

if [ -d "$JEUS_HOME/config/ubuntu" ]; then
  echo "updating hostname in $JEUS_HOME/config/ubuntu/JEUSMain.xml"
  sed -i "s/__CONTAINER_HOSTNAME__/$CONTAINER_HOSTNAME/g" "$JEUS_HOME/config/ubuntu/JEUSMain.xml"
  echo "renaming $JEUS_HOME/config/ubuntu"
  mv "$JEUS_HOME/config/ubuntu" "$JEUS_HOME/config/$CONTAINER_HOSTNAME"
fi

if [ -d "$JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_servlet_engine1" ]; then
	echo "renaming $JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_servlet_engine1"
  mv "$JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_servlet_engine1/" "$JEUS_HOME/config/$CONTAINER_HOSTNAME/${CONTAINER_HOSTNAME}_servlet_engine1"
fi

if [ -d "$JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_ejb_engine1" ]; then
  echo "renaming $JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_ejb_engine1"
  mv "$JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_ejb_engine1" "$JEUS_HOME/config/$CONTAINER_HOSTNAME/${CONTAINER_HOSTNAME}_ejb_engine1"
fi

if [ -d "$JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_jms_engine1" ]; then
	echo "renaming $JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_jms_engine1"
  mv "$JEUS_HOME/config/$CONTAINER_HOSTNAME/ubuntu_jms_engine1" "$JEUS_HOME/config/$CONTAINER_HOSTNAME/${CONTAINER_HOSTNAME}_jms_engine1"
fi



nohup jeus &
sleep 20
nohup jeusadmin `hostname -f ` -Uadministrator -Pchangeme boot &




