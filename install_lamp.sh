#!/bin/bash
apt-get update

apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks sshpass

apt-get -y install apache2 libapache2-mod-perl2
apt-get -y install libcrypt-ssleay-perl libwww-perl libhtml-parser-perl libwww-mechanize-perl
apt-get -y install php5
a2enmod ssl
a2ensite default-ssl
apt-get -y install php5-mcrypt
php5enmod mcrypt
apt-get -y install php5-gd
apt-get -y install php5-curl
apt-get -y install php5-mysql
service apache2 restart

apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks

echo mysql-server mysql-server/root_password password $1 | debconf-set-selections  
echo mysql-server mysql-server/root_password_again password $1 | debconf-set-selections 

apt-get -y install mysql-server
apt-get -y install libmysqld-dev libdb-dev
