#!/bin/bash -ex

#DEBUG="-g"

autoreconf -ivf
CXXFLAGS="${CXXFLAGS} ${DEBUG} -I/opt/local/include" LDFLAGS="${LDFLAGS} ${DEBUG} -L/opt/local/lib -lcppunit" ./configure --prefix=/opt/local -enable-64bit --with-crypto-backend=botan --with-botan=/opt/local --with-sqlite3=/opt/local --with-objectstore-backend-db && make -j 4 all && make check && sudo make install && sudo chown -R uri *
