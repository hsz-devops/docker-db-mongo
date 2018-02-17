#!/usr/bin/env bash
#
# v2.0.0-mongo    2018-02-16     webmaster@highskillz.com
#
set -e
set -o pipefail
#set -x

[ "$1" == "" ] && exit -1

CERT_DAYS="${CERT_DAYS:-730}"
CERT_TYPE="rsa:2048"

TARGET_CERT_DIR="$1"

mkdir -p "${TARGET_CERT_DIR}"
pushd "${TARGET_CERT_DIR}"

if [ ! -f ./mongodb-cert.crt ] && [ ! -f ./mongodb-cert.key ]; then
    openssl req \
        -new \
        -newkey ${CERT_TYPE} \
        -days ${CERT_DAYS} \
        -nodes \
        -x509 \
        -subj "/C=GB/ST=London/L=London/O=ez123/CN=db-mongo-3x" \
        -out    ./mongodb-cert.crt \
        -keyout ./mongodb-cert.key
    FORCE_CERT_CAT=1

fi
[ ! -f ./mongodb.pem ] && FORCE_CERT_CAT=1

if [ -n "${FORCE_CERT_CAT}" ]; then
    cat ./mongodb-cert.key ./mongodb-cert.crt > ./mongodb-key.pem
fi
popd
