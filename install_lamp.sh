#!/bin/bash
apt-get update

# set up a silent install of MySQL
# the following commands set the MySQL root password when you install the mysql-server package.
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password Pass1word'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password Pass1word'

# install the LAMP stack
apt-get -y install lamp-server^

#Restart all the installed services to verify that everything is installed properly

echo -e "\n"

service apache2 restart && service mysql restart > /dev/null

echo -e "\n"

if [ $? -ne 0 ]; then
   echo "Please Check the Install Services, There is some $(tput bold)$(tput setaf 1)Problem$(tput sgr0)
else
   echo "Installed Services run $(tput bold)$(tput setaf 2)Sucessfully$(tput sgr0)"
fi

echo -e "\n"
