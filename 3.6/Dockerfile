# v2.0.0    2018-02-17     webmaster@highskillz.com
#
FROM mongo:3.6

LABEL maintainer="webdev@highskillz.com"

# ENV MONGO_INITDB_ROOT_USERNAME
# ENV MONGO_INITDB_ROOT_PASSWORD

COPY ./src/docker-entrypoint.keygen.sh  /usr/local/bin
COPY ./src/gen_self_signed_cert.sh      /usr/local/bin
RUN chmod a+rxX /usr/local/bin/*.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.keygen.sh"]
#CMD ["mongod"]
