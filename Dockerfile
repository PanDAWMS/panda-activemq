FROM openjdk:18-alpine

ARG VERSION=5.17.1
ARG ACTIVEMQ=apache-activemq-${VERSION}
ENV ACTIVEMQ_HOME /opt/activemq
ENV ACTIVEMQ_DATA /data/activemq
ENV ACTIVEMQ_PIDFILE ${ACTIVEMQ_HOME}/tmp/activemq.pid

RUN apk --no-cache add wget && \
    wget https://archive.apache.org/dist/activemq/${VERSION}/${ACTIVEMQ}-bin.tar.gz && \
    tar xvfz ${ACTIVEMQ}-bin.tar.gz && \
    mv ${ACTIVEMQ} ${ACTIVEMQ_HOME} && \
    addgroup -S activemq && \
    adduser -S -G activemq activemq && \
    chown -R activemq:activemq ${ACTIVEMQ_HOME} && \
    chmod -R 777 ${ACTIVEMQ_HOME} && \
    mkdir -p ${ACTIVEMQ_DATA} && \
    chmod -R 777 ${ACTIVEMQ_DATA}

EXPOSE 1883 5672 8161 61613 61614 61616

USER activemq
WORKDIR ${ACTIVEMQ_HOME}

CMD ["/bin/sh", "-c", "bin/activemq console -Djetty.host=0.0.0.0"]
