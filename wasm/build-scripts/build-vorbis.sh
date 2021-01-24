#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/vorbis
CFLAGS="-s USE_PTHREADS=1 $OPTIM_FLAGS -I$BUILD_DIR/include"
LDFLAGS="-L$BUILD_DIR/lib"
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-linux                                   # use i686 linux
  --enable-shared=no                                  # disable shared library
  --enable-docs=no
  --enable-examples=no
  --enable-fast-install=no
  --disable-oggtest                                   # disable oggtests
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh && \
  CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS emconfigure ./configure "${CONF_FLAGS[@]}")
# (cd $LIB_PATH && \
#   CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS emconfigure ./autogen.sh "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
