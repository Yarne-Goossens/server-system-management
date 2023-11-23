#!/bin/bash

subzone=$1
nameserver="yarne-goossens.sasm.uclllabs.be"

if [ -z "$1" ]
then
  echo "No argument supplied"
  exit 1
fi

cat << EOF >> /etc/bind/zones/db.$subzone.$nameserver
\$TTL    300
@       IN      SOA     ns.$subzone.$nameserver. admin.$nameserver. (
                              1         ; serial
                            300         ; refresh
                            300         ; retry
                            300         ; expire
                            300 )       ; negative Cache TTL
;
@       IN      NS      ns.$nameserver.
@       IN      A       193.191.176.67
ns      IN      A       193.191.176.67

EOF

echo "Zone file made"

cat << EOF >> /etc/bind/named.conf.yoda-zones
zone "$subzone.$nameserver" {
    type master;
    file "/etc/bind/zones/db.$subzone.$nameserver";
};
EOF

echo "Zone added to named.conf.yoda-zones"

serial=$(grep -Po '\d+(?=\s+; serial)' /etc/bind/zones/db.$nameserver)
new_serial=$(("$serial"+1))
end=$(grep -Po '\s+; serial' /etc/bind/zones/db.$nameserver)
soa=$(grep -Po '\d+\s+; serial' /etc/bind/zones/db.$nameserver)

sed -i "s/$soa/$new_serial$end/g" /etc/bind/zones/db.$nameserver

cat << EOF >> /etc/bind/zones/db.$nameserver
$subzone  IN NS ns.$nameserver.
EOF

systemctl restart bind9

echo "Done"
