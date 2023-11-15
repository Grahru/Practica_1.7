#!/bin/bash
set -ex 
#Muestra comandos
#Actualizar repo
apt update
#Actualizar paquetes
# apt upgrade -y
source .env

# Eliminamos instalaciones previas
rm -rf /tmp/wp-cli.phar
# Descargamos el archivo wp-cli.phar del repositorio oficial de WP-CLI. Los archivos .phar son unos archivos similares a los archivos .jar de Java
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le asignamos permisos de ejecución al archivo wp-cli.phar.
chmod +x /tmp/wp-cli.phar

# Movemos el archivo wp-cli.phar al directorio /usr/local/bin/ con el nombre wp para poder utilizarlo sin necesidad de escribir la ruta completa donde se encuentra.
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones anteriores
rm -rf /var/www/html/*

# Utilizamos el parámetro --path para indicar el directorio donde queremos descargar el código fuente de WordPress. Por ejemplo:
wp core download --locale=es_ES --path=/var/www/html --allow-root

# Creamos la base de datos y el usuario para WordPress.
mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"

# Crear el archivo de configuración wp-config.php para WordPress con el siguiente comando:
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --path=/var/www/html \
  --allow-root

#Instalamos Wordpress
wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$CERTIFICATE_EMAIL\
  --path=/var/www/html \
  --allow-root
chown -R www-data:www-data /var/www/html 
