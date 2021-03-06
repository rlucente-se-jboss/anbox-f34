# Install Anbox on Fedora 34
The scripts and these instructions contain the commands necessary
to run the [Android Team Awareness Kit (ATAK)](https://www.civtak.org/)
on a Fedora 34 instance.

## Build and install custom kernel with ashmem and binder drivers
Copy or clone this repository to the target host where you'll install
this kernel and run anbox. Get the repo using:

    cd ~
    git clone https://github.com/rlucente-se-jboss/anbox-f34.git
    cd anbox-f34

NB: Make sure to also modify the `git config` options to match your
git username and email in the `build-anbox-kernel.sh` script.

You'll need the `ashmem` and `binder` drivers so run the following
command and provide your password when requested for `sudo`:

    ./build-anbox-kernel.sh

This will take an hour or more to complete. Be patient. When the
build finishes, install the newly built custom kernel using:

    ./install-anbox-kernel.sh

And then reboot the system to use the custom kernel.

## Verify drivers are available
You can run a [simple test](https://docs.anbox.io/userguide/install.html#install-kernel-modules)
to make sure that a device was created for ashmem:

    ls /dev/ashmem

At a minimum, you should see:

    /dev/ashmem

You can confirm the built-in `binder` driver is available using:

    modinfo binder

You should see:

    name:           binder
    filename:       (builtin)
    license:        GPL v2
    file:           drivers/android/binder
    parm:           debug_mask:uint
    parm:           devices:charp

Make sure to enable the binderfs environment using:

    sudo mkdir /dev/binderfs
    sudo mount -t binder binder /dev/binderfs

The above commands need to be run at each reboot, but it would be
better to make sure this is persisted if possible.

The directory `/dev/binderfs` matches expectations for anbox's
`session-manager` at start up.

You can validate that all the needed devices are present using:

    ls /dev/{ashmem,binder*}

You should see:

    /dev/ashmem
    /dev/binderfs:
    binder  binder-control  hwbinder  vndbinder

## Install snap for anbox
You'll need [snap](https://snapcraft.io/install/snap-store/fedora)
to install Anbox. Run the following command to install a minimum
graphical environment as well as both `snap` and the `adb` tool to
install APK files:

    sudo dnf -y install android-tools gnome-shell gnome-terminal snapd
    sudo systemctl set-default graphical.target

Restart the system to ensure that the graphical environment and
snap paths are available.

## Install anbox
Run the following command to [install anbox](https://docs.anbox.io/userguide/install.html#install-the-anbox-snap):

    snap install --devmode --beta anbox

Enter your password when prompted.

## Install Android Team Awareness Kit (ATAK)
Before launching Anbox, we need to do the following:

    sudo setenforce 0

Yes, this is a terrible thing to do, but I haven't sorted out the
SELinux changes for the binder device yet. But this is a really bad
thing to do. Seriously.

Launch Anbox by starting the `Android Application Manager` within
the `Activities` menu on the Fedora Worstation desktop.

Download the [Android Team Awareness Kit](https://d1n17y91d2yw11.cloudfront.net/dist/ATAK-4.3.0.4-67479c44-civ-release.apk)
and install it using the following command:

    adb install ATAK-4.3.0.4-67479c44-civ-release.apk

The ATAK application will appear within the `Anbox Application
Manager` window on your desktop. You can now launch that application.

At this point, ATAK will launch and request several permissions.
It then exits. I'm not sure why but I suspect there are missing
devices, etc.
