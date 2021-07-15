#!/usr/bin/env bash

cd ~/kernel/x86_64/

sudo dnf -y update
sudo dnf -y install --nogpgcheck $(ls *.rpm | grep -v debug)

