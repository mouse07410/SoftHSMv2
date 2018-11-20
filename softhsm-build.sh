#!/bin/bash -x

#DEBUG="-g"

make distclean
bash ./autogen.sh
./configure --prefix=/opt/local -enable-64bit --with-openssl=/opt/local --with-botan=/opt/local --with-sqlite3 --disable-eddsa CC=clang CPPUNIT_CFLAGS="-I/opt/local/include" CFLAGS="-maes -mpclmul -mrdrnd -msse2 -mssse3 -msse4.2 -mtune=native -Os -Ofast -std=gnu11 ${DEBUG}" LDFLAGS="${DEBUG} -L/opt/local/lib" CPPFLAGS="-I/opt/local/include" CXX=clang++ CXXFLAGS="-maes -mpclmul -mrdrnd -msse2 -mssse3 -msse4.2 -mtune=native -Os -Ofast -std=gnu++17 ${DEBUG}"
# Make sure configuration succeeded
if [ $? != 0 ]; then
   echo "SoftHSMv2 configure script failed!"
   exit 1
fi
# Build, check, and install SoftHSMv2
make -j4 all && make check && sudo make install && sudo chown -R uri *
if [ $? != 0 ]; then
   echo "SoftHSMv2 build, check, or install failed!"
   exit 1
fi

# If we're here, SoftHSMv2 compiled, passed its tests, and installed OK
echo "SoftHSMv2 installation completed"
exit 0

# Perhaps as yet another strong test - try libp11 tests that use SoftHSMv2...
cd ../libp11 && make check
