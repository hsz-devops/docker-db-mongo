#!/bin/bash
set -e
set -m

mongodb_cmd="mongod"

cmd="$mongodb_cmd --config /etc/mongod.base.conf --master"

# we use the configs in /etc/mongod.conf by default
# we only override via CLI if necessary

[ "$AUTH" == "no" ] && cmd="$cmd --noauth"

#[ "$IPV6_ENABLED" != "no" ]  && cmd="$cmd --ipv6"
#
[ "$JOURNALING"  == "no"  ] &&  cmd="$cmd --nojournal"
[ "$OPLOG_SIZE"  != ""    ] &&  cmd="$cmd --oplogSize $OPLOG_SIZE"

[ "$HTTP_ENABLED" == "yes" ] &&  cmd="$cmd --httpinterface"
[ "$REST_ENABLED" == "yes" ] &&  cmd="$cmd --rest"

[ "$STORAGE_ENGINE" != "" ] &&  cmd="$cmd --storageEngine $STORAGE_ENGINE"

[ "$SSL_DISABLED"     == "yes" ] && cmd="$cmd --sslMode none"
[ "$SSL_PEM_KEY_PATH" != ""    ] && cmd="$cmd --sslPEMKeyFile $SSL_PEM_KEY_PATH"

# generate self-signed certificate for SSL if no certs are found
/opt/.docker-build/gen_self_signed_cert.sh  /var/lib/mongodb/_cert

$cmd &

if [ ! -f /var/lib/mongodb/.mongodb_password_set ]; then
    /opt/.docker-build/set_mongodb_password.sh
fi

fg