#!/bin/bash
sleep 30
apt-get update && apt-get upgrade

apt-get -y install apache2

echo mysql-server mysql-server/root_password password $1 | debconf-set-selections  
echo mysql-server mysql-server/root_password_again password $1 | debconf-set-selections 

apt-get -y install mysql-server

apt-get -y install php5 libapache2-mod-php5

/etc/init.d/apache2 restart
