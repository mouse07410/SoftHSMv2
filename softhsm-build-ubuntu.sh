#!/bin/bash -x

#DEBUG="-g"

make distclean
bash ./autogen.sh
./configure --prefix=/opt/local -enable-64bit --with-openssl=/usr --with-botan=/opt/local --with-sqlite3 --enable-eddsa CPPUNIT_CFLAGS="-I/opt/local/include" CFLAGS="-march=native -Os -Ofast -std=gnu99 ${DEBUG}" LDFLAGS="${DEBUG} -L/opt/local/lib" CPPFLAGS="-I/opt/local/include" CXX=g++ CXXFLAGS="-march=native -Os -Ofast -std=gnu++17 ${DEBUG}"
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
