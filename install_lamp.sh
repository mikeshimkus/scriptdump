#!/bin/bash
apt-get update

echo mysql-server mysql-server/root_password password $1 | debconf-set-selections  
echo mysql-server mysql-server/root_password_again password $1 | debconf-set-selections 

apt-get -y install mysql-server

apt-get -y install lamp-server^
