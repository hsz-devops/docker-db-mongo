# v1.0.0    2016-06-20     webmaster@highskillz.com
#
FROM ubuntu:14.04
# based on tutum/mongo

MAINTAINER HighSkillz <webdev@highskillz.com>
#      via Tutum Labs <support@tutum.co>

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-get update \
    && \
    apt-get install -y \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        openssl \
        ssl-cert \
    && \
    apt-get install -y --force-yes \
        pwgen mongodb-org \
        mongodb-org-server \
        mongodb-org-shell \
        mongodb-org-mongos \
        mongodb-org-tools \
    && \
    echo "mongodb-org hold"        | dpkg --set-selections && \
    echo "mongodb-org-server hold" | dpkg --set-selections && \
    echo "mongodb-org-shell hold"  | dpkg --set-selections && \
    echo "mongodb-org-mongos hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold"  | dpkg --set-selections

# ------------------------------------------------------------
VOLUME [ "/var/lib/mongodb", "/var/log/mongodb" ]

EXPOSE 27017 28017

# ------------------------------------------------------------
# ENV AUTH        no
# ENV JOURNALING  no

# disable these for production
ENV HTTP_ENABLED  yes
ENV REST_ENABLED  yes

# ------------------------------------------------------------
WORKDIR /opt/.docker-build/
ADD     ./src/*  ./
RUN chmod -R a+x ./*.sh

# ------------------------------------------------------------
ADD ./cfg/mongod.base.conf /etc

# ------------------------------------------------------------
CMD ["/opt/.docker-build/run.sh"]
