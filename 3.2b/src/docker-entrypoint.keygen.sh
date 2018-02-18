#!/usr/bin/env bash
#
# v2.1.0-mongo    2018-02-18     webmaster@highskillz.com
#
set -e
set -o pipefail
#set -x

# ----------------------------------------------------------------
mongodb_cmd="mongod"

#cmd="$mongodb_cmd --config /etc/mongod.base.conf --master"
cmd="$mongodb_cmd "

# ----------------------------------------------------------------
[ "${MGO__AUTH}" == "no" ] && cmd="$cmd --noauth"

[ "$MGO__IPV6_ENABLED" != "no" ]  && cmd="$cmd --ipv6"

[ "${MGO__JOURNALING}"  == "no"  ] &&  cmd="$cmd --nojournal"
[ "${MGO__OPLOG_SIZE}"  != ""    ] &&  cmd="$cmd --oplogSize $OPLOG_SIZE"

[ "${MGO__HTTP_ENABLED}" == "yes" ] &&  cmd="$cmd --httpinterface"
[ "${MGO__REST_ENABLED}" == "yes" ] &&  cmd="$cmd --rest"

cmd="$cmd --storageEngine ${MGO__STORAGE_ENGINE:-wiredTiger}"

# ----------------------------------------------------------------
if [ "${MGO__SSL_DISABLED}" == "yes" ]; then
    MGO__SSL_MODE="none"
else
    MGO__SSL_MODE="${MGO__SSL_MODE:-requireSSL}"
    MGO__SSL_KEYDIR="${MGO__SSL_KEYDIR:-/etc/ssl}"

    cmd="$cmd --sslMode       ${MGO__SSL_MODE}"
    cmd="$cmd --sslPEMKeyFile ${MGO__SSL_KEYDIR}/mongodb-key.pem"

    [ "${MGO__SSL_FORCE_NEW_KEY}" == "yes" ] && KEYGEN_FORCE="--force"
    /usr/local/bin/gen_self_signed_cert.sh ${KEYGEN_FORCE} "${MGO__SSL_KEYDIR}" "${MGO__SSL_HOSTNAME}"
fi

case "$1" in
    # for convenience, we detect "bash" or "shell" to override the default entrypoint
    "bash")
        shift 1
        ;&
    "shell")
        exec bash $@
        ;;
    "${mongodb_cmd}")
        shift 1
        ;&
    *)
        exec /usr/local/bin/docker-entrypoint.sh $cmd $@
        ;;
esac
