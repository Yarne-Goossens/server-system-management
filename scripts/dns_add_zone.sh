#!/bin/bash

subzone=$1
nameserver="yarne-goossens.sasm.uclllabs.be"
ns_record="ns.$subzone.$nameserver"
dns_config='zone "'$subzone'.yarne-goossens.sasm.uclllabs.be" {
    type master;
    file "/etc/bind/zones/db.'$subzone'.yarne-goossens.sasm.uclllabs.be";
};'
zone_config='$TTL    300
@       IN      SOA     ns.'$subzone'.yarne-goossens.sasm.uclllabs.be. admin.yarne-goossens.sasm.uclllabs.be. (
                            '"$(date +'%Y%m%d%H%M%S')"'  ; Serial
                            300         ; Refresh
                            300         ; Retry
                            300         ; Expire
                            300 )       ; Negative Cache TTL
;
@       IN      NS      ns.yarne-goossens.sasm.uclllabs.be.

@       IN      A       193.191.176.67
ns      IN      A       193.191.176.67'


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

bash -c "echo -e '$zone_config' >> /etc/bind/zones/db.'$subzone'.yarne-goossens.sasm.uclllabs.be"
chown bind:bind "/etc/bind/zones/db.'$subzone'.yarne-goossens.sasm.uclllabs.be"

bash -c "echo -e '$dns_config' >> /etc/bind/named.conf.yoda-zones"

echo "done"
