# hacert

## New certificates for a domain
Assuming the container name is *hacert*

### Issue certificates
```
docker exec hacert certbot certonly --standalone --non-interactive --agree-tos --email you@example.com --http-01-port=54321 --cert-name example.com -d example.com -d www.example.com
```

### Add certificates to Haproxy
```
docker exec hacert /update-haproxy-certs.sh
```

