# Kafka and Zookeeper

FROM java:openjdk-8-jdk

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

ENV ZK_HOSTS localhost:2181
ENV KM_VERSION 1.3.3.4
ENV KM_CONFIGFILE "conf/application.conf"

# Install Kafka, Zookeeper and other needed things
RUN apt-get update && \
    apt-get install -y zookeeper wget supervisor dnsutils && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
    rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

# Install kafka-manager
RUN mkdir -p /tmp && \
    cd /tmp && \
    wget https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.tar.gz && \
    tar xxf ${KM_VERSION}.tar.gz && \
    cd /tmp/kafka-manager-${KM_VERSION} && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/${KM_VERSION} /tmp/kafka-manager-${KM_VERSION} && \
    rm -rf /var/lib/apt/lists/*

ADD scripts/start-kafka.sh /usr/bin/start-kafka.sh
ADD scripts/start-kafka-manager.sh /usr/bin/start-kafka-manager.sh

# Supervisor config
ADD supervisor/kafka.conf supervisor/zookeeper.conf supervisor/kafka-manager.conf /etc/supervisor/conf.d/

# JMX Config
ENV JMX_PORT 9999
ENV KAFKA_JMX_OPTS "-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.rmi.port=12346 -Djava.rmi.server.hostname=172.17.0.1"

# 2181 is zookeeper, 9092 is kafka, 9000 is kafka-manager
EXPOSE 2181 9092 9000


CMD ["supervisord", "-n"]
