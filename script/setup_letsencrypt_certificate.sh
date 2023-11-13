#!/bin/bash
set -ex 
#Muestra comandos
#Actualizar repo
apt update
#Actualizar paquetes
#apt upgrade -y
source .env

# Realizamos la instalación y actualización de snapd.
sudo snap install core
sudo snap refresh core

# Eliminamos si existiese alguna instalación previa de certbot con apt.
sudo apt remove certbot -y

# Instalamos el cliente de Certbot con snapd.
sudo snap install --classic certbot

# Creamos una alias para el comando certbot.
sudo ln -fs /snap/bin/certbot /usr/bin/certbot

# Obtenemos el certificado y configuramos el servidor web Apache.
sudo certbot --apache -m $CERTIFICATE_EMAIL --agree-tos --no-eff-email -d $CERTIFICATE_DOMAIN --non-interactive
