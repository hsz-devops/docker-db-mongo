# v1.0.0    2016-06-20     webmaster@highskillz.com
#
FROM ubuntu:14.04
# based on tutum/mongo

MAINTAINER HighSkillz <webdev@highskillz.com>
#      via Tutum Labs <support@tutum.co>
#      via github.com/aptible/docker-mongodb(for SSL)

# ------------------------------------------------------------
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
    && \
    apt-get install -y \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        openssl \
        ssl-cert \
        pwgen \
    && \
    echo "..."

# ------------------------------------------------------------
VOLUME [ "/var/lib/mongodb", "/var/log/mongodb" ]

EXPOSE 27017 28017

# ------------------------------------------------------------
# ENV AUTH        no
# ENV JOURNALING  no

# disable these for production
ENV HTTP_ENABLED  yes
ENV REST_ENABLED  yes

ENV MONGO_VERSION   2.6.12
ENV MONGO_SHA1SUM   5568f745bc76b414116a8ae957364cdb47eb4b6e
#ENV MONGO_GPG_KEY   7F0CEB10
ENV MONGO_SSL_MODE  preferSSL

# ------------------------------------------------------------
WORKDIR /opt/.docker-build/
ADD     ./src/  ./
RUN chmod -R a+x ./*.sh

RUN ./install-mongodb-ssl.sh

# ------------------------------------------------------------
ADD ./cfg/mongod.base.conf /etc

# ------------------------------------------------------------
CMD [ "./run.sh" ]
