#!/bin/bash -ex

#DEBUG="-g"

autoreconf -ivf
CXXFLAGS="${CXXFLAGS} ${DEBUG} -I/opt/local/include" LDFLAGS="${LDFLAGS} ${DEBUG} -L/opt/local/lib -lcppunit" ./configure --prefix=/opt/local -enable-64bit --with-openssl=/opt/local --with-botan=/opt/local --with-sqlite3=/opt/local --with-objectstore-backend-db --disable-eddsa && make -j 4 all && make check && sudo make install && sudo chown -R ur20980 *
