#!/bin/bash
set -ex


source install_lamp.sh

source deploy_wordpress_withwpcli.sh

source setup_letsencrypt_certificate.sh 