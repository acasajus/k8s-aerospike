FROM aerospike:3.12.1

MAINTAINER Adrià Casajús <acasajus@infern.us>

ADD kubectl kubectl

ENV DOCKERIZE_VERSION v0.4.0

RUN apt-get update && apt-get install -y wget \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY aerospike.conf /etc/aerospike/aerospike.conf
