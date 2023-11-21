#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Add a FQDN"
    exit 1
fi

fqdn=$1

result=$(nslookup "$fqdn")

echo "$result"

if [[ $result == *"can't find"* ]]; then
  echo "Subdomain does not exist"
else
  echo "Subdomain exists"
fi

document_root="/var/www/html/$fqdn"

#mkdir "$document_root"

echo "<VirtualHost *:80>"
echo "        ServerAdmin webmaster@$fqdn"
echo "        DocumentRoot $document_root"
echo "        ServerName $fqdn"
echo "        ServerAlias www.$fqdn"
echo "        ErrorLog ${APACHE_LOG_DIR}/${fqdn}_error.log"
echo "        CustomLog ${APACHE_LOG_DIR}/${fqdn}_access.log combined"
echo "</VirtualHost>"

echo "welcome $fqdn" #> "$document_root/index.html"
echo "welcome www.$fqdn" #> /var/www/html/www.$fqdn/index.html

#a2ensite "$fqdn.conf"

#systemctl reload apache2

