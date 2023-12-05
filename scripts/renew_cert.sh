#!/bin/bash

/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt_test
/root/.acme.sh/acme.sh --force --ecc --issue -k ec-384 --dns dns_nsupdate -d yarne-goossens.sasm.uclllabs.be -d secure.yarne-goossens.sasm.uclllabs.be -d supersecure.yarne-goossens.sasm.uclllabs.be
/root/.acme.sh/acme.sh --ecc -i -d yarne-goossens.sasm.uclllabs.be --cert-file /etc/pki/yarne-goossens.sasm.uclllabs.be.crt --key-file /etc/pki/yarne-goossens.sasm.uclllabs.be.key --fullchain-file /etc/pki/fullchain.pem --reloadcmd "systemctl reload apache2.service"'

