#!/bin/bash
adirScript="$( cd "$( dirname "$${BASH_SOURCE[0]}" )" && pwd )"

cat > $adirScript/gen_self_sign.sh <<"EOFGEN"

cat > foo.conf <<"EOFREQ"
[ req ]
default_bits           = 2048
default_keyfile        = keyfile.pem
distinguished_name     = req_distinguished_name
attributes             = req_attributes
prompt                 = no
output_password        = mypass

[ req_distinguished_name ]
C                      = GB
ST                     = Test State or Province
L                      = Test Locality
O                      = Organization Name
OU                     = Organizational Unit Name
CN                     = Common Name
emailAddress           = test@email.address

[ req_attributes ]
challengePassword      = p12837834985048
EOFREQ

openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm -f server.pass.key
openssl req -new -key server.key -out server.csr -config foo.conf
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
mkdir -p /mattermost-docker-build/volumes/web/cert/
cp -f server.crt /mattermost-docker-build/volumes/web/cert/cert.pem
cp -f server.key /mattermost-docker-build/volumes/web/cert/key-no-password.pem

EOFGEN
