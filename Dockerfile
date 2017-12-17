FROM ubuntu:16.04

RUN apt-get update && apt-get install -y make qemu

WORKDIR /mnt
VOLUME $(pwd):/mnt

LABEL factory.for=kos-factory
LABEL maintainer="Kristoffer A. Iversen"

CMD make
