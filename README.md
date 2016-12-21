# Tiny Apache Zookeeper

[![Circle CI](https://circleci.com/gh/vektorcloud/zookeeper.svg?style=svg)](https://circleci.com/gh/vektorcloud/zookeeper)

Tiny [Apache Zookeeper](http://zookeeper.apache.com) Docker image


## Running

      docker run --rm -ti -e MYID=1 -p 2181:2181 -p 2888:2888 -p 3888:3888 quay.io/vektorcloud/zookeeper

