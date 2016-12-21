#!/usr/bin/dumb-init /bin/bash
set -e

env |grep "ZOOKEEPER_"
# Write Zookeeper Configuration
cat /dev/null > /opt/zookeeper/conf/zoo.cfg
for opt in $(env |grep ^ZOOKEEPER_); do
  echo $opt | awk '{gsub(/ZOOKEEPER_/, ""); gsub(/_/, "."); {print}}' >> /opt/zookeeper/conf/zoo.cfg
done

echo "${MYID:=1}" > "$ZOOKEEPER_dataDir/myid"

exec "$@"
