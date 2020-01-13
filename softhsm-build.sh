#!/bin/bash -x

#DEBUG="-g"

make distclean || true
bash ./autogen.sh

if [ -z "$OPENSSL_DIR" ]; then
    OPENSSL_DIR="/opt/local"
fi
PPATH="$OPENSSL_DIR"

PKG_CONFIG_PATH="$OPENSSL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"
OPENSSL_CONF="$OPENSSL_DIR/etc/openssl.cnf"

./configure --prefix=$PPATH -enable-64bit \
    --with-openssl=$PPATH --with-botan=/opt/local --with-sqlite3 \
    --enable-eddsa \
    CC=clang \
    CXX=clang++ \
    CPPUNIT_CFLAGS="-I${PPATH}/include -I/opt/local/include" \
    CFLAGS="-march=native -Os -Ofast -std=gnu11 ${DEBUG}" \
    LDFLAGS="${DEBUG} -L${PPATH}/lib -L/opt/local/lib" \
    CPPFLAGS="-I${PPATH}/include -I/opt/local/include" \
    CXXFLAGS="-march=native -I${PPATH}/include -Os -Ofast -std=gnu++17 ${DEBUG}"

# Make sure configuration succeeded
if [ $? != 0 ]; then
   echo "SoftHSMv2 configure script failed!"
   exit 1
fi
# Build, check, and install SoftHSMv2
make -j4 all && make check && sudo make install && sudo chown -R ur20980 *
if [ $? != 0 ]; then
   echo "SoftHSMv2 build, check, or install failed!"
   exit 1
fi

# If we're here, SoftHSMv2 compiled, passed its tests, and installed OK
echo "SoftHSMv2 installation completed"
exit 0

# Perhaps as yet another strong test - try libp11 tests that use SoftHSMv2...
cd ../libp11 && make check
