#!/bin/bash -ex

# Install swig
sudo apt-get install -y swig

# Install HIREDIS
sudo apt-get install -y libhiredis0.14 libhiredis-dev

# Install libnl3
sudo apt-get install -y \
         libnl-3-200 \
         libnl-3-dev \
         libnl-genl-3-200 \
         libnl-genl-3-dev \
         libnl-route-3-200 \
         libnl-route-3-dev \
         libnl-nf-3-200 \
         libnl-nf-3-dev \
         libnl-cli-3-200 \
         libnl-cli-3-dev

pushd sonic-swss-common

./autogen.sh
fakeroot debian/rules binary

popd

mkdir -p target
cp *.deb target/

