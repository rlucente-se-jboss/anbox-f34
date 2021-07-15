#!/usr/bin/env bash

sudo dnf -y update
sudo dnf -y install fedpkg ccache

pushd $(dirname $0)

if [ ! -d kernel ]
then
    fedpkg clone -a kernel
fi

cd kernel
sudo dnf -y builddep kernel.spec

git config --global user.email "rlucente@comcast.net"
git config --global user.name "Rich Lucente"

git checkout origin/f34
git checkout -b ashmem_binder
git branch -u origin/f34

if [ -z $(grep ANDROID kernel-local) ]
then
    cat >> kernel-local <<EOF
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDER_DEVICES=binder
CONFIG_ASHMEM=y
EOF
fi

git commit -am 'enable ashmem and binder'

fedpkg local --without configchecks

popd
