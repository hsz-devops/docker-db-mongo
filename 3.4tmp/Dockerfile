# v2.2.0    2018-02-20     webmaster@highskillz.com
#
FROM mongo:3.4

LABEL maintainer="webdev@highskillz.com"
LABEL authors="webdev@highskillz.com,tapanhalani231@gmail.com"

# ----------------------------------------------------------------
# please set this the 1st time mongo is installed
# ENV MONGO_INITDB_ROOT_USERNAME=
# ENV MONGO_INITDB_ROOT_PASSWORD=

ENV \
    MGO__AUTH=yes \
    MGO__JOURNALING=yes \
    MGO__STORAGE_ENGINE=wiredTiger \
#   MGO__OPLOG_SIZE= \
    MGO__STORAGE_DIR_PER_DB=yes \
    MGO__STORAGE_DIR_FOR_INDEXES=yes \
    MGO__HTTP_ENABLED=no \
    MGO__REST_ENABLED=no \
    MGO__IPV6_ENABLED=no \

    MGO__SSL_DISABLED=no \
    MGO__SSL_MODE=requireSSL \
    MGO__SSL_FORCE_NEW_KEY=no \

# we are keeping the cert in the DB folder to have persistency
    MGO__SSL_KEYDIR=/data/_certs \
    MGO__SSL_HOSTNAME=CHANGE-ME-to--the-public-DNS-name-used-by-clients \
    MGO__SSL_SELFSIGN_GEN=yes \

    MGO__REPLICATION_ENABLED=no \
#   MGO__REPLSET_NAME= \
    MGO__CLUSTER_INTERNAL_AUTH_ENABLED=no \
    MGO__CLUSTER_INTERNAL_AUTH_MODE=keyFile \

# need to test whether we can mount a volume with a volume
    MGO__CLUSTER_INTERNAL_AUTH_KEYFILE=/data/_certs/mongodb-internal-auth.keyfile \

    MGO__EXTRA_FLAGS="" \

    MGO_______dummy=1


# ----------------------------------------------------------------
COPY ./src/docker-entrypoint.keygen.sh  /usr/local/bin
COPY ./src/gen_self_signed_cert.sh      /usr/local/bin
RUN chmod a+rxX /usr/local/bin/*.sh

# ----------------------------------------------------------------
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.keygen.sh"]
CMD ["mongod"]
