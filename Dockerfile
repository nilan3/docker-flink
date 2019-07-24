FROM ubuntu:16.04

ARG MESOS_VERSION=1.6.0
ARG FLINK_VERSION=1.8.1

ARG DISTRO=ubuntu
ARG CODENAME=xenial

RUN apt-get update && apt-get install -my wget gnupg && apt-get install -y lsb-core

RUN echo "deb http://repos.mesosphere.com/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF \
 && apt-get -y update \
 && apt-get install -y openjdk-8-jdk \
 && apt-get install -y ant \
 && apt-get install ca-certificates-java \
 && update-ca-certificates -f \
 && touch /usr/local/bin/systemctl && chmod +x /usr/local/bin/systemctl \
 && apt-get -y install --no-install-recommends "mesos=${MESOS_VERSION}*" wget libcurl3-nss \
 && apt-get -y install libatlas3-base libopenblas-base \
 && update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3 \
 && update-alternatives --set liblapack.so.3 /usr/lib/openblas-base/liblapack.so.3 \
 && ln -sfT /usr/lib/libblas.so.3 /usr/lib/libblas.so \
 && ln -sfT /usr/lib/liblapack.so.3 /usr/lib/liblapack.so \
 && wget http://apache.mirror.anlx.net/flink/flink-1.8.1/flink-${FLINK_VERSION}-bin-scala_2.11.tgz -O /tmp/flink.tgz \
 && mkdir /flink \
 && tar zxf /tmp/flink.tgz -C /flink --strip-components 1 \
 && ldconfig

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV FLINK_HOME=/flink
ENV PATH=/flink/bin:$PATH

EXPOSE 8081 6123

CMD "start-local.sh" 
