#!/bin/bash

cd /etc/letsencrypt
certbot renew --post-hook "
# Combine certs for usage in haproxy
for domain in /etc/letsencrypt/live/*/ ; do
    cat /etc/letsencrypt/live/$domain/fullchain.pem /etc/letsencrypt/live/$domain/privkey.pem > /etc/letsencrypt/$domain.pem
done

service haproxy restart"

