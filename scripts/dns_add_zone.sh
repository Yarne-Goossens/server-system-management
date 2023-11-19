#!/bin/bash

subzone=$1
nameserver="yarne-goossens.sasm.uclllabs.be"
ns_record="ns.$subzone.$nameserver"
zone_config='zone "'$subzone'.yarne-goossens.sasm.uclllabs.be" {
    type master;
    file "/etc/bind/zones/db.'$subzone'.yarne-goossens.sasm.uclllabs.be";
};'

if [ -z "$1" ]
then
  echo "No argument supplied"
  exit 1
fi

echo "$subzone"
echo "$nameserver"
echo "$ns_record"
echo "$zone_config"
