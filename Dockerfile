# Dockerizing MongoDB: Dockerfile for building MongoDB images Based on ubuntu:latest, installs MongoDB 
FROM quay.io/inok/baseimage
# ...put your own build instructions here... Installation: Install MongoDB.

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

RUN apt-get update \
	&& apt-get install -y curl \
	&& rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver pgp.mit.edu --recv-keys DFFA3DCF326E302C4787673A01C4E7FAAAB2461C

ENV MONGO_VERSION 2.6.3

RUN curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz" -o mongo.tgz \
	&& curl -SL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-$MONGO_VERSION.tgz.sig" -o mongo.tgz.sig \
	&& gpg --verify mongo.tgz.sig \
	&& tar -xvf mongo.tgz -C /usr/local --strip-components=1 \
	&& rm mongo.tgz*

# Define mountable directories.
VOLUME ["/data"]
# Define working directory.
WORKDIR /data
# Expose ports.
#   - 27017: process 
#   - 28017: http
EXPOSE 27017 
# EXPOSE 28017
CMD ["mongod","-f", "/data/mongod.conf"]
 
