FROM alpine:3.21

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required btrfs-tools 
RUN apk add --no-cache \
 gcc make linux-headers musl-dev \
 zlib-dev zlib-static python3-dev openssl-dev openssl-libs-static \
 git util-linux-dev util-linux-static py3-setuptools \
 lzo-dev autoconf automake e2fsprogs-static e2fsprogs-dev \
 zstd-static zstd-dev eudev-dev meson ninja \
 bash xz

ENV XZ_OPT=-e9
COPY build-static-btrfs-tools.sh build-static-btrfs-tools.sh
RUN chmod +x ./build-static-btrfs-tools.sh
RUN bash ./build-static-btrfs-tools.sh
