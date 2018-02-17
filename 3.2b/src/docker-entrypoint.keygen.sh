#!/usr/bin/env bash
#
# v2.0.0-mongo    2018-02-16     webmaster@highskillz.com
#
set -e
set -o pipefail
#set -x

mongodb_cmd="mongod"

#cmd="$mongodb_cmd --config /etc/mongod.base.conf --master"
cmd="$mongodb_cmd "

# we use the configs in /etc/mongod.conf by default
# we only override via CLI if necessary

[ "${MGODB__AUTH}" == "no" ] && cmd="$cmd --noauth"

#[ "$MGODB_IPV6_ENABLED" != "no" ]  && cmd="$cmd --ipv6"
#
[ "${MGODB__JOURNALING}"  == "no"  ] &&  cmd="$cmd --nojournal"
[ "${MGODB__OPLOG_SIZE}"  != ""    ] &&  cmd="$cmd --oplogSize $OPLOG_SIZE"

[ "${MGODB__HTTP_ENABLED}" == "yes" ] &&  cmd="$cmd --httpinterface"
[ "${MGODB__REST_ENABLED}" == "yes" ] &&  cmd="$cmd --rest"

cmd="$cmd --storageEngine ${MGODB__STORAGE_ENGINE:-wiredTiger}"

if [ "${MGODB_SSL_DISABLED}" == "yes" ]; then
    MGODB__SSL_MODE="none"
fi
MGODB__SSL_MODE="${MGODB__SSL_MODE:-requireSSL}"
MGODB__SSL_KEYFILE="${MGODB__SSL_KEYFILE:-/etc/ssl}"

cmd="$cmd --sslMode       ${MGODB__SSL_MODE}"
cmd="$cmd --sslPEMKeyFile ${MGODB__SSL_KEYFILE}/mongodb-key.pem"

/usr/local/bin/gen_self_signed_cert.sh  ${MGODB__SSL_KEYFILE}

if [ "$1" == "mongod" ]; then
    exec /usr/local/bin/docker-entrypoint.sh $@
else
    exec /usr/local/bin/docker-entrypoint.sh $cmd $@
fi