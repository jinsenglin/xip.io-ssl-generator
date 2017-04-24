#!/bin/sh

set -e
set -x

# load parameters
IP=$ip

# setup parameters
SSL_DIR=$IP
DOMAIN=$IP
PASSPHRASE=""
SUBJ="
C=US
ST=Connecticut
O=
localityName=New Haven
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

# generate
mkdir -p "$SSL_DIR"
openssl genrsa -out "$SSL_DIR/$IP.key" 2048

openssl req -x509 -new -nodes -key "$SSL_DIR/$IP.key" -sha256 -days 365 -out "$SSL_DIR/ca.pem"

openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$IP.key" -out "$SSL_DIR/$IP.csr" -passin pass:$PASSPHRASE
openssl x509 -req -days 365 -in "$SSL_DIR/$IP.csr" -signkey "$SSL_DIR/$IP.key" -out "$SSL_DIR/$IP.crt"
openssl rsa -pubout -in "$SSL_DIR/$IP.key" -out "$SSL_DIR/$IP.pub"

# print results
ls $SSL_DIR
cat $SSL_DIR/$IP.key
cat $SSL_DIR/ca.pem
cat $SSL_DIR/$IP.csr
cat $SSL_DIR/$IP.crt
cat $SSL_DIR/$IP.pub
