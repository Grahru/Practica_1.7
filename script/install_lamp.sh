#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizar repo
apt update

#Instalar apache
apt install apache2 -y

#Instalar MySQL
apt install mysql-server -y

#Instalar php
apt install php libapache2-mod-php php-mysql -y

#Copiar archivo de conf
cp ../conf/000-default.conf /etc/apache2/sites-available

a2enmod rewrite
systemctl restart apache2

#Copiar index
cp ../php/index.php /var/www/html
#Modificar  propietario de /var/www/html al de apache
chown -R www-data:www-data /var/www/html


