#!/bin/bash
#Autor: Yago Ésquines
#Email: yago.fut@gmail.com
#Ano: 2015
#Script de Permissionamento em um ambiente web.

# Dono e Grupo: flaptrap | www-data
chown www-data.www-data -R /www/

# Dono, Grupo e Permissão: apache - 751
chown apache.apache -R /etc/apache2/
chmod 751 -R /etc/apache2/

# Alterando permissÃ£o para arquivos comuns, .php e diretorios em /www/
chmod 644 -R /www/ 
find /www/ -iname *.php  -exec chmod 641 '{}' \;
find /www/ -type d ! -exec chmod 755 '{}' \;

# PermissÃµes para Arquivos Wordpress
find /www/ -iname .htaccess -exec chmod 444 '{}' \;
find /www/ -iname wp-config.php -exec chmod 440 '{}' \;
find /www/ -type d -iname themes -exec chmod 711 '{}' \;
