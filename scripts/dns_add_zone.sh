#!/bin/bash

subzone=$1
nameserver="yarne-goossens.sasm.uclllabs.be"
ns_record="ns.$subzone.$nameserver"
dns_config="zone "'$subzone'.'$nameserver'" {
    type master;
    file "/etc/bind/zones/db.'$subzone'.'$nameserver'";
};"
zone_config="$TTL    300
@       IN      SOA     ns.'$subzone'.'$nameserver'. admin.'$nameserver'. (
                            '"$(date +'%Y%m%d%H%M%S')"'  ; Serial
                            300         ; Refresh
                            300         ; Retry
                            300         ; Expire
                            300 )       ; Negative Cache TTL
;
@       IN      NS      ns.'$subzone'.'$nameserver'.
@       IN      NS      ns.'$nameserver'.

@       IN      A       193.191.176.67
ns      IN      A       193.191.176.67"


if [ -z "$1" ]
then
  echo "No argument supplied"
  exit 1
fi

echo "$subzone"
echo "$nameserver"
echo "$ns_record"
echo "$dns_config"
echo "$zone_config"

echo -e $zone_config >> /etc/bind/zones/db.$subzone.$nameserver

echo -e $dns_config >> /etc/bind/named.conf.yoda-zones

serial=$(("$(date +'%Y%m%d%H%M%S')"))
end=$(grep -Po '\s+; Serial' /etc/bind/zones/db.$nameserver)
soa=$(grep -Po '\d+\s+; Serial' /etc/bind/zones/db.$nameserver)

sed -i "s/$soa/$serial$end/g" /etc/bind/zones/db.$nameserver

echo -e "$subzone       IN NS ns.'$nameserver'" >> /etc/bind/zones/db.$nameserver

systemctl restart bind9

echo "done"
