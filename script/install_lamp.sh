#!/bin/bash
set -x 
#Muestra comandos
echo "Esto es una prueba"
#Actualizar repo
apt update
#Actualizar paquetes
#apt upgrade -y

#Instalar apache
apt install apache2 -y

#systemctl start apache2
#systemctl stop apache2
#systemctl restart apache2
#systemctl reload apache2
#systemctl status apache2

#Instalar MySQL
sudo apt install mysql-server -y

#Instalar php
sudo apt install php libapache2-mod-php php-mysql -y

#Copiar archivo de conf
cp ../conf/000-default.conf /etc/apache2/sites-available

systemctl restart apache2
#Copiar index
cp ../php/index.php /var/www/html
#Modificar  propietario de /var/www/html al de apache
chown -R www-data:www-data /var/www/html


