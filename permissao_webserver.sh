#!/bin/bash
#Autor: Yago Ésquines
#Email: yago.fut@gmail.com
#Ano: 2015
#Script de Permissionamento em um ambiente web.

DIR=/var/www
APACHE_DIR=/etc/apache2/

# Dono e Grupo: www-data | www-data
chown www-data.www-data -R $DIR

# Dono, Grupo e Permissão: apache - 751
chown www-data.www-data -R $APACHE_DIR
chmod 751 -R $APACHE_DIR

# Alterando permissão para arquivos comuns, .php e diretorios em /www/
chmod 644 -R $DIR
find $DIR -iname '*.php'  -exec chmod 641 '{}' \;
find $DIR -type d ! -exec chmod 755 '{}' \;

# Permissões para Arquivos Wordpress
find $DIR -iname .htaccess -exec chmod 444 '{}' \;
find $DIR -iname wp-config.php -exec chmod 440 '{}' \;
find $DIR -type d -iname themes -exec chmod 711 '{}' \;
