#!/usr/bin/env bash

if [ -z $1 ]; then
	echo "Usage: $0 <IP>"
	exit 1
fi

IP=$1

# Specify where we will install
# the xip.io certificate
SSL_DIR="/tmp/ssl/$IP.xip.io"

# Set the wildcarded domain
# we want to use
DOMAIN="*.$IP.xip.io"

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=US
ST=Connecticut
O=
localityName=New Haven
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

# Create our SSL directory
# in case it doesn't exist
sudo mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
sudo openssl genrsa -out "$SSL_DIR/$IP.xip.io.key" 2048
sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/$IP.xip.io.key" -out "$SSL_DIR/$IP.xip.io.csr" -passin pass:$PASSPHRASE
sudo openssl x509 -req -days 365 -in "$SSL_DIR/$IP.xip.io.csr" -signkey "$SSL_DIR/$IP.xip.io.key" -out "$SSL_DIR/$IP.xip.io.crt"

# Extracting the public key from an RSA keypair
openssl rsa -pubout -in "$SSL_DIR/$IP.xip.io.key" -out "$SSL_DIR/$IP.xip.io.pub"
