#!/bin/bash
service ssh start
sed -i "s/{PORT}/$PORT/g" /etc/apache2/apache2.conf
mkdir /var/lock/apache2
mkdir /var/run/apache2
/usr/sbin/apache2ctl -D FOREGROUND