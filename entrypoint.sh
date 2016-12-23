#!/usr/bin/dumb-init /bin/bash
set -e

env |grep "ZOOKEEPER_"
# Write Zookeeper Configuration
cat /dev/null > /opt/zookeeper/conf/zoo.cfg
cfg="zoo-cfg-extra="
for opt in $(env |grep ^ZOOKEEPER_); do
  echo $opt | awk '{gsub(/ZOOKEEPER_/, ""); gsub(/_/, "."); {print}}' >> /opt/zookeeper/conf/zoo.cfg
  cfg=$cfg$(echo $opt | awk '{gsub(/ZOOKEEPER_/, ""); gsub(/_/, "."); gsub(/=/, "\\="); {print}}')\&
done
echo "$cfg" >> /opt/exhibitor/exhibitor.conf
echo "${MYID:=1}" > "$ZOOKEEPER_dataDir/myid"

if [ -n "$WITH_ZOOKEEPER"] ; then
  java -jar /opt/exhibitor/exhibitor.jar --port 8080 --defaultconfig /opt/exhibitor/exhibitor.conf --configtype file --fsconfigdir /opt/zookeeper/conf
else 
  exec "$@"
fi
