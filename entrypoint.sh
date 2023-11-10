#!/bin/bash

PASSWORD=$(openssl rand -base64 32)
SUBJ="/C=US/ST=somewhere/L=someplace/O=haproxy/OU=haproxy/CN=haproxy.selfsigned.invalid"
TEMP_DIR=/tmp
KEYS_DIR=/etc/letsencrypt
KEY=${TEMP_DIR}/haproxy_key.pem
CERT=${TEMP_DIR}/haproxy_cert.pem
CSR=${TEMP_DIR}/haproxy.csr
DEFAULT_PEM=${KEYS_DIR}/default.pem

# Check if default.pem has been created
if [ ! -e ${DEFAULT_PEM} ]; then
  openssl genrsa -des3 -passout pass:${PASSWORD} -out ${KEY} 2048 &> /dev/null
  openssl req -new -key ${KEY} -passin pass:${PASSWORD} -out ${CSR} -subj ${SUBJ} &> /dev/null
  cp ${KEY} ${KEY}.org &> /dev/null
  openssl rsa -in ${KEY}.org -passin pass:${PASSWORD} -out ${KEY} &> /dev/null
  openssl x509 -req -days 3650 -in ${CSR} -signkey ${KEY} -out ${CERT} &> /dev/null
  cat ${CERT} ${KEY} > ${DEFAULT_PEM}
  echo ${PASSWORD} > /password.txt
fi


# Run Supervisor
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf -n
