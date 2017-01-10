FROM quay.io/vektorcloud/maven:latest

RUN apk --no-cache add bash && \
    apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add dumb-init

RUN VERSION="3.4.9" && \
  PACKAGE="zookeeper-$VERSION.tar.gz" && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  tar xvf $PACKAGE -C /opt/ && \
  ln -sv /opt/zookeeper-* /opt/zookeeper && \
  rm -v /tmp/zookeeper*

# Exhibitor
RUN apk add --no-cache openssl && \
  wget https://raw.githubusercontent.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml -O /tmp/pom.xml && \
  apk del openssl && \
  cd /tmp && \
  mvn clean package && \
  mkdir /opt/exhibitor && \
  cd /opt/exhibitor && \
  mv /tmp/target/exhibitor-*.jar /opt/exhibitor/exhibitor.jar && \
  rm -Rv /tmp/* && \
  rm -Rv /root/.m2 

COPY exhibitor.conf /opt/exhibitor/exhibitor.conf

ENV PATH "$PATH:/opt/zookeeper/bin"

ENV ZOOKEEPER_tickTime="2000"
ENV ZOOKEEPER_dataDir="/opt/zookeeper/data"
ENV ZOOKEEPER_clientPort="2181"
ENV ZOOKEEPER_initLimit="5"
ENV ZOOKEEPER_syncLimit="2"

EXPOSE 2181 2888 3888 8080
VOLUME ["$ZOOKEEPER_dataDir"]

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
