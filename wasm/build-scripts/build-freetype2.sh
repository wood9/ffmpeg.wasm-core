#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/freetype2
CFLAGS="-s USE_PTHREADS=1 $OPTIM_FLAGS"
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                 # install library in a build directory for FFmpeg to include
  --host=i686-gnu                                     # use i686 linux
  --enable-shared=no                                  # not to build shared library
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && \
  emconfigure ./autogen.sh && \
  CFLAGS=$CFLAGS emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
