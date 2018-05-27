#!/usr/bin/env bash
#
# v2.1.0-mongo    2018-02-16     webmaster@highskillz.com
#
set -e
set -o pipefail
set -x

# [--force] [<cert_dir_name> [<cert_name_cn>]]

# ----------------------------------------------------------------
[ "$1" == "" ] && exit -1

if [ "$1" == "--force" ]; then
    FORCE_CERT_GEN=1
    shift 1
fi

# ----------------------------------------------------------------
[ "$1" == "" ] && exit -1

TARGET_CERT_DIR="$1"
TARGET_CERT_NAME_CN="${TARGET_CERT_NAME_CN:-$2}"

CERT_DUR_DAYS="${CERT_DUR_DAYS:-730}"
CERT_TYPE="rsa:${CERT_RSA_SIZE_BITS:-2048}"

# ----------------------------------------------------------------
[ -d "${TARGET_CERT_DIR}" ] || mkdir -p "${TARGET_CERT_DIR}"
pushd "${TARGET_CERT_DIR}"
ls -la mongodb-*.* || true

# ----------------------------------------------------------------
if [ ! -f ./mongodb-cert.crt ] || [ ! -f ./mongodb-cert.key ]; then
    FORCE_CERT_GEN=1
fi
if [ "${FORCE_CERT_GEN}" == "1" ]; then
    openssl req \
        -new \
        -newkey ${CERT_TYPE} \
        -days ${CERT_DUR_DAYS} \
        -nodes \
        -x509 \
        -subj "/C=GB/ST=London/L=London/O=ez123/CN=${TARGET_CERT_NAME_CN:-$HOSTNAME}" \
        -out    ./mongodb-cert.crt \
        -keyout ./mongodb-cert.key
    FORCE_CERT_CONCAT=1
    ls -la mongodb-cert.*
else
    if [ ! -f ./mongodb-key.pem ]; then
        FORCE_CERT_CONCAT=1
    fi
fi
if [ -n "${FORCE_CERT_CONCAT}" ]; then
    cat ./mongodb-cert.key ./mongodb-cert.crt > ./mongodb-key.pem
    ls -la mongodb-key.*
fi

# ----------------------------------------------------------------
ls -la mongodb-*.*
popd
