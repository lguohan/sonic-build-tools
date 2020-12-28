#!/bin/bash
#
# provision vmss virtual machine
#

sgdisk -n 0:0:0 -t 0:8300 -c 0:root /dev/sdc
mkfs.ext4 /dev/sdc1

mkdir /data
mount /dev/sdc1 /data

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl stop docker
sed -i 's/^ExecStart=.*$/& --data-root \/data\/docker/' /lib/systemd/system/docker.service
systemctl daemon-reload
systemctl start docker

apt-get install -y qemu binfmt-support qemu-user-static
