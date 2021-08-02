#!/usr/bin/env bash

pushd $(dirname $0)/kernel/x86_64

sudo dnf -y update
#sudo rpm -ihv --force $(ls *.rpm | grep -v debug)
sudo dnf -y install --nogpgcheck $(ls *.rpm | grep -v debug)

popd

