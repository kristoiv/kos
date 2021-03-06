FROM ubuntu:16.04

RUN apt-get update && apt-get install -y make qemu xz-utils libpython2.7

WORKDIR /mnt
VOLUME $(pwd):/mnt

LABEL factory.for=kos-factory
LABEL maintainer="Kristoffer A. Iversen"

CMD make
