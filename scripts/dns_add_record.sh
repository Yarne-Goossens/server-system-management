#!/bin/bash

type="A"

type_check() {
  if [ "$type" != "A" ] && [ "$type" != "MX" ] && [ "$type" != "CNAME" ]; then
    echo "Enter a valid record (A,CNAME,MX)"
    exit 1
  fi
}

while getopts "t:" opt; do
  case $opt in
    t)
      type="$OPTARG"
      type_check
      ;;
    *)
      echo "Enter a valid record (A,CNAME,MX)"
      exit 1
      ;;
    esac
done

shift $((OPTIND-1))

name="$1"
ip_or_alias="$2"
domain="$3"

if [ "$type" == "A" ]; then
    if [ "$#" -ne 3 ]; then
      echo "Needs 4 arguments"
      exit 1
    fi

    echo "Adding A record to /etc/bind/zones/db.$domain"

    echo -e "$name IN A $ip_or_alias" >> /etc/bind/zones/db.$domain

elif [ "$type" == "MX" ]; then
    if [ "$#" -ne 3 ]; then
      echo "Needs 4 arguments"
      exit 1
    fi

    echo "Adding A and MX record to /etc/bind/zones/db.$domain"

    echo -e "IN     MX     10  $name.$domain." >> /etc/bind/zones/db.$domain
    echo -e "$name IN A $ip_or_alias" >> /etc/bind/zones/db.$domain

elif [ "$type" == "CNAME" ]; then
    if [ "$#" -ne 2 ]; then
      echo "Needs 3 arguments"
      exit 1
    fi

    domain="${ip_or_alias#*.}"

    echo "Adding CNAME record to /etc/bind/zones/db.$domain"

    echo -e "$name IN CNAME $ip_or_alias" >> /etc/bind/zones/db.$domain
fi

serial=$(grep -Po '\d+(?=\s+; Serial)' /etc/bind/zones/db.$domain)
new_serial=$(("$serial"+1))
end=$(grep -Po '\s+; Serial' /etc/bind/zones/db.$domain)
soa=$(grep -Po '\d+\s+; Serial' /etc/bind/zones/db.$domain)

sed -i "s/$soa/$new_serial$end/g" /etc/bind/zones/db.$domain

systemctl restart bind9

echo "Done"

