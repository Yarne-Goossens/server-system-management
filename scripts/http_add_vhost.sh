#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Add a FQDN"
    exit 1
fi

fqdn=$1

result=$(nslookup "$fqdn")

if [[ $result == *"can't find"* ]]; then
  echo "Subdomain does not exist"
  exit 1
else
  echo "Subdomain exists"
fi

document_root="/var/www/html/yoda_$fqdn"

mkdir "$document_root"

cat << EOF > "/etc/apache2/sites-available/yoda_${fqdn}.conf"
<VirtualHost *:80>
        ServerAdmin webmaster@$fqdn
        DocumentRoot $document_root
        ServerName $fqdn
        #ServerAlias www.$fqdn
        ErrorLog ${APACHE_LOG_DIR}/yoda_${fqdn}_error.log
        CustomLog ${APACHE_LOG_DIR}/yoda_${fqdn}_access.log combined
</VirtualHost>
EOF

echo "welcome $fqdn" > "$document_root/index.html"
#echo "welcome www.$fqdn" > /var/www/html/www.$fqdn/index.html

a2ensite "yoda_${fqdn}.conf"

systemctl reload apache2

