#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Add a FQDN"
    exit 1
fi

fqdn=$1
echo "$fqdn"

document_root="/var/www/html/$fqdn"

echo "$document_root"
#mkdir "$document_root"

echo "<VirtualHost *:80>"
echo "        ServerAdmin webmaster@$fqdn"
echo "        DocumentRoot $document_root"
echo "        ServerName $fqdn"
echo "        ServerAlias www.$fqdn"
echo "        ErrorLog ${APACHE_LOG_DIR}/${fqdn}_error.log"
echo "        CustomLog ${APACHE_LOG_DIR}/${fqdn}_access.log combined"
echo "</VirtualHost>"
