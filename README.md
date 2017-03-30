Kafka in Docker
===

This repository provides everything you need to run Kafka in Docker. It also provides a Kafka-Manager instance
so that you can have a look on what's happening in the Kafka.

This is mainly intented to provide to the developper a convienent Kafka installation. This is not for production use!

For convenience also contains a packaged proxy that can be used to get data from
a legacy Kafka 7 cluster into a dockerized Kafka 8.

Why?
---
The main hurdle of running Kafka in Docker is that it depends on Zookeeper.
Compared to other Kafka docker images, this one runs both Zookeeper and Kafka
in the same container. This means:

* No dependency on an external Zookeeper host, or linking to another container
* Zookeeper and Kafka are configured to work together out of the box
* Kafka-Manager is also preconfigured out of the box (the cluster declaration is still needed)

Run
---

```bash
docker run -p 2181:2181 -p 9092:9092 -p 9000:9000 --env ADVERTISED_HOST=127.0.0.1 --env ADVERTISED_PORT=9092 xenix/kafka
```

Using Kafka-manager
-------------------

The first time you are connecting to http://localhost:9000, there is no cluster defined. Add one with "localhost:2181" as Zookeeper instance, and enable JMX.

Then, you can have a look to the cluster.

Running the proxy
-----------------

Take the same parameters as the spotify/kafka image with some new ones:
 * `CONSUMER_THREADS` - the number of threads to consume the source kafka 7 with
 * `TOPICS` - whitelist of topics to mirror
 * `ZK_CONNECT` - the zookeeper connect string of the source kafka 7
 * `GROUP_ID` - the group.id to use when consuming from kafka 7

```bash
docker run -p 2181:2181 -p 9092:9092 \
    --env ADVERTISED_HOST=`boot2docker ip` \
    --env ADVERTISED_PORT=9092 \
    --env CONSUMER_THREADS=1 \
    --env TOPICS=my-topic,some-other-topic \
    --env ZK_CONNECT=kafka7zookeeper:2181/root/path \
    --env GROUP_ID=mymirror \
    spotify/kafkaproxy
```

In the box
---
* **xenix/kafka**

  The docker image with Kafka, Zookeeper and KafkaManager. Built from the `kafka`
  directory.

* **xenix/kafkaproxy**

  The docker image with Kafka, Zookeeper and a Kafka 7 proxy that can be
  configured with a set of topics to mirror.

Public Builds
---

https://registry.hub.docker.com/u/xenix/kafka/

https://registry.hub.docker.com/u/xenix/kafkaproxy/

Build from Source
---

    docker build -t xenix/kafka kafka/
    docker build -t xenix/kafkaproxy kafkaproxy/

Todo
---

* Not particularily optimzed for startup time.
* Better docs

