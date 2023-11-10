#!/bin/bash

cd /etc/letsencrypt/live

# Combine certs for usage in haproxy
for domain in */ ; do
    cat $domain/fullchain.pem $domain/privkey.pem > ../${domain::-1}.pem
done

service haproxy restart

