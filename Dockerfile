FROM openjdk:18-alpine

ARG VERSION=5.17.1
ARG ACTIVEMQ=apache-activemq-${VERSION}
ENV ACTIVEMQ_HOME /opt/activemq
ENV ACTIVEMQ_DATA /appdata/activemq
ENV ACTIVEMQ_PIDFILE ${ACTIVEMQ_HOME}/tmp/activemq.pid
ENV ACTIVEMQ_EXTRA_CONF /data/activemq

RUN apk --no-cache add util-linux wget python3 && \
    wget https://archive.apache.org/dist/activemq/${VERSION}/${ACTIVEMQ}-bin.tar.gz && \
    tar xvfz ${ACTIVEMQ}-bin.tar.gz && \
    mv ${ACTIVEMQ} ${ACTIVEMQ_HOME} && \
    addgroup -S activemq && \
    adduser -S -G activemq activemq && \
    mkdir ${ACTIVEMQ_HOME}/tmp && \
    mkdir -p ${ACTIVEMQ_DATA} && \
    mkdir -p ${ACTIVEMQ_EXTRA_CONF} && \
    chmod -R 777 ${ACTIVEMQ_HOME} && \
    chmod -R 777 ${ACTIVEMQ_DATA} && \
    chmod -R 777 ${ACTIVEMQ_EXTRA_CONF} && \
    chown -R activemq:activemq ${ACTIVEMQ_HOME}

EXPOSE 1883 5672 8161 61613 61614 61616

WORKDIR ${ACTIVEMQ_HOME}

# make a wrapper script to launch service
RUN echo $'#!/bin/sh \n\
set -m \n\
cp ${ACTIVEMQ_EXTRA_CONF}/*.xml ${ACTIVEMQ_HOME}/conf/ \n\
cp ${ACTIVEMQ_EXTRA_CONF}/*.properties ${ACTIVEMQ_HOME}/conf/ \n\
${ACTIVEMQ_HOME}/bin/activemq console -Djetty.host=0.0.0.0 \n ' > ${ACTIVEMQ_HOME}/bin/run-activemq-services

RUN chmod +x ${ACTIVEMQ_HOME}/bin/run-activemq-services

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
