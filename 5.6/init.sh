#!/bin/bash
cat >/etc/motd <<EOL
  ______                             __
 /_  __/___ _____  ____ ____  ____  / /_
  / / / __ \/ __ \/ __ \/ _ \/ __ \/ __/
 / / / /_/ / / / / /_/ /  __/ / / / /_
/_/  \__,_/_/ /_/\__, /\___/_/ /_/\__/
   _____       _/____/ __  _
  / ___/____  / /_  __/ /_(_)___  ____  _____
  \__ \/ __ \/ / / / / __/ / __ \/ __ \/ ___/
 ___/ / /_/ / / /_/ / /_/ / /_/ / / / (__  )
/____/\____/_/\__,_/\__/_/\____/_/ /_/____/

http://tangentsolutions.co.za/
EOL
cat /etc/motd

service ssh start
sed -i "s/{PORT}/$PORT/g" /etc/apache2/apache2.conf
mkdir /var/lock/apache2
mkdir /var/run/apache2
/usr/sbin/apache2ctl -D FOREGROUND