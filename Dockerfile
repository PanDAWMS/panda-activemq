FROM openjdk:18-alpine

ARG VERSION=5.17.1
ARG ACTIVEMQ=apache-activemq-${VERSION}
ENV ACTIVEMQ_HOME /opt/activemq
ENV ACTIVEMQ_DATA /appdata/activemq
ENV ACTIVEMQ_PIDFILE ${ACTIVEMQ_HOME}/tmp/activemq.pid
ENV ACTIVEMQ_EXTRA_CONF /data/activemq

RUN apk --no-cache add wget && \
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

USER activemq
WORKDIR ${ACTIVEMQ_HOME}

CMD /bin/sh -c "cp ${ACTIVEMQ_EXTRA_CONF}/*.xml conf/; bin/activemq console -Djetty.host=0.0.0.0"
