FROM quay.io/vektorcloud/openjdk:latest

RUN apk --no-cache add bash && \
    apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add dumb-init

RUN VERSION="3.4.9" && \
  PACKAGE="zookeeper-$VERSION.tar.gz" && \
  mkdir /opt && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  tar xvf $PACKAGE -C /opt/ && \
  ln -sv /opt/zookeeper-* /opt/zookeeper && \
  rm -v /tmp/zookeeper*

COPY entrypoint.sh /

ENV PATH "$PATH:/opt/zookeeper/bin"

ENV ZOOKEEPER_tickTime="2000"
ENV ZOOKEEPER_dataDir="/var/run/zookeeper"
ENV ZOOKEEPER_clientPort="2181"
ENV ZOOKEEPER_initLimit="5"
ENV ZOOKEEPER_syncLimit="2"

EXPOSE 2181 2888 3888
VOLUME ["$ZOOKEEPER_dataDir"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]
