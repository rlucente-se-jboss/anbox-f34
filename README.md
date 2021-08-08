# Install Anbox on Fedora 34
The scripts and these instructions contain the commands necessary
to run the [Android Team Awareness Kit (ATAK)](https://www.civtak.org/)
on a Fedora 34 instance.

## Build and install custom kernel with ashmem and binder drivers
Copy or clone this repository to the target host where you'll install
this kernel and run anbox. Get the repo using:


    cd ~
    git clone https://github.com/rlucente-se-jboss/anbox-f34.git

Make sure to also modify the `git config` options to match your git
username and email in the `build-kernel.sh` script. You'll need the
`ashmem` and `binder` drivers so run the following command and
provide your password when requested for `sudo`:

    cd ~/anbox-f34/build-kernel
    ./build-kernel.sh

This will take an hour or more to complete. Be patient. When the
build finishes, install the newly built custom kernel using:

    cd ~/anbox-f34/build-kernel
    ./install-kernel.sh

And then reboot the system to use the custom kernel.

## Verify drivers are available
You can run a [simple test](https://docs.anbox.io/userguide/install.html#install-kernel-modules)
to make sure that the devices were created for both ashmem and binder:

    ls /dev/{ashmem,binder}

You should see:

    /dev/ashmem
    /dev/binder

## Install minimal graphical environment
You'll need a minimal graphical environment to run anbox as well
as install android APK files. Run the following command to install
a minimal environment and the `adb` tool to install APK files:

    sudo dnf -y install gnome-shell gnome-terminal android-tools lxc
    sudo systemctl set-default graphical.target

## Build anbox natively
Anbox can be built natively by installing all the needed development
libraries and applying a small patch set. The patches are pretty
brute force to get around build errors, but there may be a cleaner
way to do this by submitting patches to the `cmake` files that drive
the build.

Use the following commands to build and install anbox:

    cd ~/anbox-f34/build-anbox
    ./build-anbox.sh

The script does a `sudo make install` so please supply your password
for `sudo` when prompted.

## Run anbox
Before launching Anbox, we need to do the following:

    sudo setenforce 0

Yes, this is a terrible thing to do, but I haven't sorted out the
SELinux changes for the binder device yet. But this is a really bad
thing to do. Seriously.

Run the various anbox managers by leveraging the included script. Make
sure to first enable the binderfs environment using:

    sudo mkdir /dev/binderfs
    sudo mount -t binder binder /dev/binderfs

Anbox can be run by typing the following command:

    cd ~/anbox-f34/run-anbox
    export ANBOX_LOG_LEVEL=debug && ./run-anbox.sh

Please supply your password for `sudo` when prompted.

NB: Couple of problems here. The `run-anbox.sh` script has a line
to launch a daemonized `container-manager` that does not return.
We'll need a way to detect when the `container-manager` is fully
started. The `session-manager` is throwing exceptions and segfaults.
There are likely build issues, permissions issues, and a myriad of
other problems. I welcome any contributions to help iron this all
out. The errors that I'm seeing wrt `session-manager` are:

    $ /usr/local/bin/anbox session-manager
    [ 2021-08-02 17:57:57] [client.cpp:48@start] Failed to start container: Failed to start container: Failed to set config item lxc.group.devices.deny
    [ 2021-08-02 17:57:57] [session_manager.cpp:164@operator()] Lost connection to container manager, terminating.
    [ 2021-08-02 17:57:57] [daemon.cpp:61@Run] Container is not running
    [ 2021-08-02 17:57:57] [session_manager.cpp:164@operator()] Lost connection to container manager, terminating.
    Stack trace (most recent call last) in thread 2641:
    #8    Object "", at 0xffffffffffffffff, in

## Install Android Team Awareness Kit (ATAK)
Download the [Android Team Awareness Kit](https://d1n17y91d2yw11.cloudfront.net/dist/ATAK-4.3.0.4-67479c44-civ-release.apk)
and install it using the following command:

    adb install ATAK-4.3.0.4-67479c44-civ-release.apk

The ATAK application will appear within the `Anbox Application
Manager` window on your desktop. You can now launch that application.
