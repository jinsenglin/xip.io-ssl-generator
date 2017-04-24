#!/bin/sh

set -e
set -x

# load parameters
IP=$ip

# setup parameters
C=TW
ST=Taiwan
L=Taipei
O=LIN
OU=Jim
CN=$IP
ROOT_CN=root.cn.localhost
emailAddress=admin@$CN

# create ca private key
# file: ca-key.pem
openssl genrsa 2048 > ca-key.pem

# create ca self-signed certificate
# file: root.crt
openssl req -new -sha256 -x509 -nodes -days 3600 -key ca-key.pem -out root.crt -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$ROOT_CN/emailAddress=$emailAddress"

# create (web) server private key and csr for $CN
# file: $CN.server.key
# file: $CN.server.csr
openssl req -new -sha256 -keyout $CN.server.key -out $CN.server.csr -days 365 -newkey rsa:2048 -nodes -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN/emailAddress=$emailAddress"

# create (web) server certificate by using ca private key to sign server csr for $CN
# file: $CN.server.crt
openssl x509 -req -days 365 -sha1 -CA root.crt  -CAkey ca-key.pem -CAcreateserial -in $CN.server.csr -out $CN.server.crt

# print results
cat ca-key.pem
cat root.crt
cat $CN.server.key
cat $CN.server.csr
cat $CN.server.crt
