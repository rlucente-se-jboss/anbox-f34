#!/usr/bin/env bash

pushd $(dirname $0)

rm -fr anbox properties-cpp

sudo dnf -y install \
    boost-devel \
    cmake \
    commoncpp2-devel \
    dbus-devel \
    doxygen \
    expat-devel \
    gcc-c++ \
    gcovr \
    git \
    glm-devel \
    gmock-devel \
    gtest-devel \
    lcov \
    libcap-devel \
    lxc-devel \
    make \
    mesa-libEGL-devel \
    patch \
    protobuf-devel \
    protobuf-lite-devel \
    python3 \
    SDL2-devel \
    SDL2_image-devel \
    systemd-devel

git clone https://github.com/lib-cpp/properties-cpp.git

pushd properties-cpp
patch -p1 < ../properties-cpp.patch

mkdir build
cd build
cmake -D GMOCK_INSTALL_DIR=/usr/include ..
make
sudo make install

popd 

git clone https://github.com/anbox/anbox.git --recurse-submodules

pushd anbox
patch -p1 < ../anbox.patch

mkdir build
cd build
cmake ..
make
sudo make install

popd
popd

