
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# util-linux
cd $WORKSPACE
curl -sL https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.4.tar.xz | tar x --xz
cd util-linux-2.40.4
./autogen.sh && ./configure --prefix=/usr --enable-static --disable-shared  --disable-all-programs \
  --enable-libmount --enable-libblkid --enable-libuuid
make -j8
make install

# libeconf
cd $WORKSPACE
git clone https://github.com/openSUSE/libeconf.git
cd libeconf
LDFLAGS="-static --static -no-pie -s" meson setup builddir
meson configure -Dprefix=/usr -Dbuildtype=minsize -Ddefault_library=static --strip builddir
cd builddir
ninja
ninja install

# btrfs-progs
cd $WORKSPACE
git clone https://github.com/kdave/btrfs-progs.git
cd btrfs-progs
git checkout v6.16.1
./autogen.sh
 LDFLAGS="-static -no-pie -s -leconf -lintl" EXTRA_PYTHON_LDFLAGS=${LDFLAGS} ./configure --prefix=/usr/local/btrfs-progsmm --disable-documentation --disable-backtrace --disable-shared
make btrfs.box

tar vcJf ./btrfs.tar.xz btrfs.box
mv ./btrfs.tar.xz /work/artifact/


