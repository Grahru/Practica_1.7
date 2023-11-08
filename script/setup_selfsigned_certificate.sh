#!/bin/bash
set -x 
#Muestra comandos
#Actualizar repo
apt update
#Actualizar paquetes
#apt upgrade -y
source .env

#Creamos certificado y una clave publica
sudo openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

# Copiamos archivos de configuracion apache
  cp ../conf/default-ssl.conf  /etc/apache2/sites-available

# Cabiamos Nombre de dominio
sed -i "s/PUT_YOUR_DOMAIN_HERE/$OPENSSL_COMMON_NAME/" /etc/apache2/sites-available/default-ssl.conf
# Habilitamos el VirtualHost
  a2ensite default-ssl.conf
#Hamilitamos el modulo ssl
  a2enmod ssl

#Configuramos que las peticiones http se redirijan a https
#Copiar archivo de conf
cp ../conf/000-default.conf /etc/apache2/sites-available

#Habilitamos el modulo rewrite
a2enmod rewrite

# Reiniciamos Apache2
systemctl restart apache2

