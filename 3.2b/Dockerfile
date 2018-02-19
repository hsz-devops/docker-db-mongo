# v2.1.0    2018-02-18     webmaster@highskillz.com
#
FROM mongo:3.2

LABEL maintainer="webdev@highskillz.com"
LABEL authors="webdev@highskillz.com,tapanhalani231@gmail.com"

# ----------------------------------------------------------------
# please set this the 1st time mongo is installed
# ENV MONGO_INITDB_ROOT_USERNAME=
# ENV MONGO_INITDB_ROOT_PASSWORD=

ENV MGO__AUTH=yes
ENV MGO__JOURNALING=yes
ENV MGO__STORAGE_ENGINE=wiredTiger
#ENV MGO__OPLOG_SIZE=
ENV MGO__HTTP_ENABLED=no
ENV MGO__REST_ENABLED=no
ENV MGO__IPV6_ENABLED=no

ENV MGO__SSL_DISABLED=no
ENV MGO__SSL_MODE=requireSSL
ENV MGO__SSL_FORCE_NEW_KEY=no
# we are keeping the cert in the DB folder to have persistency
ENV MGO__SSL_KEYDIR=/data/db/_certs
ENV MGO__SSL_HOSTNAME=CHANGE-ME-to--the-public-DNS-name-used-by-clients

ENV MGO__REPLICATION_ENABLED=no
#ENV MGO__REPLSET_NAME=
ENV MGO__CLUSTER_INTERNAL_AUTH_ENABLED=no
ENV MGO__CLUSTER_INTERAL_AUTH_MODE=keyFile

# ----------------------------------------------------------------
COPY ./src/docker-entrypoint.keygen.sh  /usr/local/bin
COPY ./src/gen_self_signed_cert.sh      /usr/local/bin
RUN chmod a+rxX /usr/local/bin/*.sh

# ----------------------------------------------------------------
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.keygen.sh"]
CMD ["mongod"]
