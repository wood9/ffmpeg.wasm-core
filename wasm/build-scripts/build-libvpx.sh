#!/bin/bash

set -euo pipefail
source $(dirname $0)/var.sh

LIB_PATH=third_party/libvpx
FLAGS="-c $OPTIM_FLAGS"
CONF_FLAGS=(
  --prefix=$BUILD_DIR                                # install library in a build directory for FFmpeg to include
  --target=generic-gnu                               # target with miminal features
  --disable-install-bins                             # not to install bins
  --disable-examples                                 # not to build examples
  --disable-tools                                    # not to build tools
  --disable-docs                                     # not to build docs
  --disable-unit-tests                               # not to do unit tests
  --extra-cflags="$FLAGS"                            # flags to use pthread and code optimization
  --extra-cxxflags="$FLAGS"                          # flags to use pthread and code optimization
)
echo "CONF_FLAGS=${CONF_FLAGS[@]}"
(cd $LIB_PATH && LDFLAGS="$FLAGS" STRIP="llvm-strip" emconfigure ./configure "${CONF_FLAGS[@]}")
emmake make -C $LIB_PATH clean
emmake make -C $LIB_PATH install -j
