#!/bin/bash
set -e

[ "$1" == "" ] && exit -1

CERT_DAYS=730
CERT_TYPE="rsa:2048"

WORK_DIR="$1"

mkdir -p "${WORK_DIR}"
pushd "${WORK_DIR}"

if [ ! -f ./mongodb-cert.crt ] && [ ! -f ./mongodb-cert.key ]; then
    openssl req \
        -new \
        -newkey ${CERT_TYPE} \
        -days ${CERT_DAYS} \
        -nodes \
        -x509 \
        -subj "/C=GB/ST=None/L=Nowhere/O=e123/CN=db-mongo-3" \
        -out    ./mongodb-cert.crt \
        -keyout ./mongodb-cert.key
fi
if [ ! -f ./mongodb.pem ]; then
    cat ./mongodb-cert.key ./mongodb-cert.crt > ./mongodb.pem
fi
popd
