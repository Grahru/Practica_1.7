#!/bin/bash

# Muestra todos los comandos que se van ejecutando
set -ex

#Actualizar repo
apt update

#Actualizar paquetes
# apt upgrade -y

# Importamos el archivo de variables .env
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
  
# Actualizamos los plugins 
  wp core update --path=/var/www/html --allow-root

  # Actualizamos los temas 
  wp theme update --all --path=/var/www/html --allow-root

  # Instalo un tema
  wp theme install $TEMA --activate --path=/var/www/html --allow-root

  # Actualizamos los plugins
  wp plugin update --all --path=/var/www/html --allow-root

  # Instalar y activar un  plugin
  wp plugin install $PLUGIN --activate --path=/var/www/html --allow-root
  wp plugin install $PLUGIN2 --activate --path=/var/www/html --allow-root

  # Habilitar permalinks
  wp rewrite structure '/%postname%/' \
    --path=/var/www/html \
    --allow-root
  
  # Modificamos automaticamente el nombre que establece por defecto el plugin wpd-hide-login
  wp option update whl_page $WORDPRESS_HIDE_LOGIN --path=/var/www/html --allow-root
  # Copiamos el nuevo archivo .htaccess
  cp ../htaccess/.htaccess /var/www/html

  #Modificamos el propietario y el grupo del directorio /var/www/html
  chown -R www-data:www-data /var/www/html