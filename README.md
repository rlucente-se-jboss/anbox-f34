# Install Anbox of F34
## Build and install custom kernel with ashmem and binder
You'll need these modules so run the following command and provide
your password when requested for `sudo`:

    ./build-anbox-kernel.sh

This will take an hour or more to complete. Be patient. When the
build finishes, install the kernel modules using:

    ./install-anbox-kernel.sh

And then reboot the system to use the custom kernel.

## Verify modules are available
You can run a [simple test](https://docs.anbox.io/userguide/install.html#install-kernel-modules) to make sure that appropriate devices have been created:

    ls /dev/{ashmem,binder}

At a minimum, you should see:

    /dev/ashmem
    /dev/binder

## Install snap for anbox
You'll need both [snap](https://snapcraft.io/install/snap-store/fedora) to install Anbox. Run the following command to do so:

    sudo dnf -y install snapd android-tools

Log off/on or restart the system to ensure that the snap paths are
available.

## Install anbox
Run the following command to [install anbox](https://docs.anbox.io/userguide/install.html#install-the-anbox-snap):

    snap install --devmode --beta anbox

Enter your password when prompted.

## Install CivTAK
Launch Anbox by doing the following:

    sudo setenforce 0

Yes, this is a terrible thing to do, but I haven't sorted out the
SELinux changes for the binder device and kernel module yet. But
this is a really bad thing to do.

Launch Anbox by starting the `Android Application Manager` within
the `Activities` menu.

Download the [Android Team Awareness Kit](https://d1n17y91d2yw11.cloudfront.net/dist/ATAK-4.3.0.4-67479c44-civ-release.apk)
and install it using the following command:

    adb install ATAK-4.3.0.4-67479c44-civ-release.apk

The ATAK application will appear with the `Anbox Application Manager`
window on your desktop. You can now launch that application.
