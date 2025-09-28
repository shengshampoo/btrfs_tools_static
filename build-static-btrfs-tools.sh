
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

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
export EXTRA_PYTHON_LDFLAGS=${LDFLAGS}
LDFLAGS="-static -no-pie -s -leconf" ./configure --prefix=/usr/local/btrfs-progsmm --disable-documentation --disable-backtrace --disable-shared
make btrfs.box

tar vcJf ./btrfs.tar.xz btrfs.box
mv ./btrfs.tar.xz /work/artifact/


