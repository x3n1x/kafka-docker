#!/bin/sh

# Optional ENV variables:
# * KM_VERSION: version of kafka manager
# * KM_CONFIGFILE: configuration
KM_HOME="/kafka-manager-${KM_VERSION}"

# Run Kafka
${KM_HOME}/bin/kafka-manager -Dconfig.file=${KM_HOME}/conf/application.conf
