#!/usr/bin/env bash

pushd $(dirname $0)

# Point to latest pre-built Anbox android image
ANDROID_IMG_URL=https://build.anbox.io/android-images/2018/07/19/android_amd64.img

# Make sure the necessary directories exist
sudo mkdir -p /var/lib/anbox/common

# If android image missing, fetch the image and validate it
if [ ! -r /var/lib/anbox/android_amd64.img ]
then
    curl -sLO $ANDROID_IMG_URL
    curl -sLO $ANDROID_IMG_URL.sha256sum
    
    if [ -z "$(sha256sum -c android_amd64.img.sha256sum | grep OK)" ]
    then
        echo "Checksum for android_amd64.img failed."
        exit 1
    fi

    sudo cp android_amd64.img /var/lib/anbox
fi

sudo restorecon -vFr /var/lib/anbox

# Launch daemons for anbox
sudo /usr/local/bin/anbox container-manager --data-path=/var/lib/anbox/common/ --android-image=/var/lib/anbox/android_amd64.img --daemon
/usr/local/bin/anbox session-manager

# Launch app mgr
/usr/local/bin/anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity

popd

