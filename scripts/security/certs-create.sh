#!/bin/bash

#set -o nounset \
#    -o errexit \
#    -o verbose \
#    -o xtrace

# Cleanup files
rm -f *.crt *.csr *_creds *.jks *.srl *.key *.pem *.der *.p12

# Generate CA key
openssl req -new -x509 -keyout snakeoil-ca-1.key -out snakeoil-ca-1.crt -days 365 -subj '/CN=ca1.test.confluentdemo.io/OU=TEST/O=CONFLUENT/L=PaloAlto/ST=Ca/C=US' -passin pass:confluent -passout pass:confluent

# Restore docker-ca-bundle.crt from backup
cp docker-ca-bundle.crt.backup docker-ca-bundle.crt

for i in kafka1 kafka2 client schemaregistry restproxy connect connectorSA controlcenter ksqlDBserver ksqlDBUser appSA badapp clientListen zookeeper mds
do
  echo "------------------------------- $i -------------------------------"
  ./certs-create-per-user.sh $i
done
