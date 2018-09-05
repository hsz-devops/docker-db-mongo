#!/usr/bin/env bash
#
# v2.2.0-mongo    2018-02-19    webmaster@highskillz.com, tapanhalani231@gmail.com
#
set -e
set -o pipefail
set -x

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

# ----------------------------------------------------------------
if [ "${MGO__REPLICATION_ENABLED}" == "yes" ]; then
    if [ -z "${MGO__REPLSET_NAME}" ]; then
        echo "Error: Missing replica set name!"
        exit -2
    fi

    cmd="$cmd --replSet $MGO__REPLSET_NAME"

    if [ "${MGO__CLUSTER_INTERNAL_AUTH_ENABLED}" == "yes" ]; then
        if [ "${MGO__CLUSTER_INTERNAL_AUTH_MODE}" == "keyFile" ]; then
            if [ -z "${MGO__CLUSTER_INTERNAL_AUTH_KEYFILE}" ]; then
                echo "Error: Missing cluster internal auth keyfile path!"
                exit -2
            fi
            if [ ! -f "${MGO__CLUSTER_INTERNAL_AUTH_KEYFILE}" ]; then
                echo "Error: Cluster internal auth keyfile does not exist!"
                exit -3
            fi

            # workaround for the fact that kubernetes mounts secrets as root:root
            # while mongodb doesn't allow access by others
            NEW_INT_CIAK="/tmp/$(basename ${MGO__CLUSTER_INTERNAL_AUTH_KEYFILE})"
            cp "${MGO__CLUSTER_INTERNAL_AUTH_KEYFILE}" "${NEW_INT_CIAK}"
            export MGO__CLUSTER_INTERNAL_AUTH_KEYFILE="${NEW_INT_CIAK}"

            chmod 0400            "${MGO__CLUSTER_INTERNAL_AUTH_KEYFILE}"
            chown mongodb:mongodb "${MGO__CLUSTER_INTERNAL_AUTH_KEYFILE}"

            cmd="$cmd --clusterAuthMode $MGO__CLUSTER_INTERNAL_AUTH_MODE --keyFile $MGO__CLUSTER_INTERNAL_AUTH_KEYFILE"
        else
            echo "Error: Only keyFile internal auth mode supported for now!"
            exit -4
        fi
    fi
fi

# ----------------------------------------------------------------
cmd="$cmd --storageEngine ${MGO__STORAGE_ENGINE:-wiredTiger}"

if [ "${MGO__STORAGE_DIR_PER_DB}" != "no" ]; then
    cmd="$cmd --directoryperdb"
fi

# ----------------------------------------------------------------
if [ "${MGO__SSL_DISABLED}" == "yes" ]; then
    MGO__SSL_MODE="none"
else
    MGO__SSL_MODE="${MGO__SSL_MODE:-requireSSL}"
    MGO__SSL_KEYDIR="${MGO__SSL_KEYDIR:-/etc/ssl}"

    cmd="$cmd --sslMode       ${MGO__SSL_MODE}"
    cmd="$cmd --sslPEMKeyFile ${MGO__SSL_KEYDIR}/mongodb-key.pem"

    if [ "${MGO__SSL_SELFSIGN_GEN}" == "yes" ]; then
        if [ "${MGO__SSL_FORCE_NEW_KEY}" == "yes" ]; then
            KEYGEN_FORCE="--force"
        fi
        /usr/local/bin/gen_self_signed_cert.sh ${KEYGEN_FORCE} "${MGO__SSL_KEYDIR}" "${MGO__SSL_HOSTNAME}"

        cmd="$cmd --sslAllowConnectionsWithoutCertificates"
    fi
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
