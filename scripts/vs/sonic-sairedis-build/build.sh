#!/bin/bash -ex

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

# Install common library
sudo dpkg -i common/libswsscommon_*.deb
sudo dpkg -i common/libswsscommon-dev_*.deb

# Install REDIS
sudo apt-get install -y redis-server
sudo sed -ri 's/^# unixsocket/unixsocket/' /etc/redis/redis.conf
sudo sed -ri 's/^unixsocketperm .../unixsocketperm 777/' /etc/redis/redis.conf
sudo sed -ri 's/redis-server.sock/redis.sock/' /etc/redis/redis.conf
sudo service redis-server start

# Start rsyslog
sudo apt-get install -y rsyslog
sudo service rsyslog start

cleanup() {
    mkdir -p ../target
    sudo cp /var/log/syslog ../target/
    sudo chmod 644 ../target/syslog
}

trap cleanup ERR

pushd sairedis

./autogen.sh
fakeroot debian/rules binary-syncd-vs

popd

mkdir -p target
cp *.deb target/
sudo cp /var/log/syslog target/
sudo chmod 644 target/syslog
