```
# if this is the very first time on the pi, do the following first:

sudo su -;
apt-get update;
apt-get upgrade;
apt-get install build-essential mongodb-server libusb-1.0-0-dev libudev-dev htop graphicsmagick;

git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout v0.29.0; (find latest version)

add `source ~/.nvm/nvm.sh` to

* ~/.bashrc
* ~/.profile

Then `reboot`

nvm install 0.10; # this could take a few hours
nvm alias default 0.10;

npm install -g forever node-gyp node-pre-gyp;

# https://github.com/rakeshpai/pi-gpio
cd ~/
git clone https://github.com/VipSaran/quick2wire-gpio-admin.git
cd quick2wire-gpio-admin
make
make install
adduser $USER gpio



# dependencies are now installed

# bundle the spacelock project with `meteor bundle`, then copy it to the PI
# copy the bundle file to the pi
# extract the `bundle.tgz` on the pi

# IF YOU HAVE NOT BUILT YET, copy spacelock bundle to `~/spacelock`. For the first build, do this:

cd ~/spacelock;
(cd programs/server && npm install);
rm -r programs/server/node_modules/fibers;
rm -r programs/server/node_modules/bcrypt;
rm -r programs/server/npm/npm-bcrypt/node_modules/bcrypt;
rm -r programs/server/npm/cfs_gridfs/node_modules/mongodb/node_modules/bson/;
rm -r programs/server/npm/npm-container/node_modules/usb/;
(cd programs/server && npm install fibers@1.0.1 bcrypt@0.7.7);
(cd programs/server/npm/npm-bcrypt && npm install bcrypt@0.7.7);
(cd programs/server/npm/cfs_gridfs/node_modules/mongodb && npm install bson@0.2.21);
(cd programs/server/npm/npm-container && npm install usb@1.0.6 --verbose);

# now test it

# After that build, move it and symlink it so it doesn't get overwritten when you update in the future.

mkdir ~/npmBuild/;
cp -R programs/server/node_modules ~/npmBuild/node_modules;
cp -R programs/server/npm ~/npmBuild/npm;

ln -s /sys/devices/virtual/gpio /sys/class/gpio

# IF YOU HAVE ALREDY BUILT, from then on, you can simply do the below to relink the npm build instead of rebuilding it each time

# bundle on dev machine with `metoer bundle spacelock.tgz`
# copy the bundle to the pi with ssh (or transmit) to /home/pi/bundle.tgz
# ssh into the pi
# `sudo su -` to get into root mode
# copy the bundle from /home/pi/bundle.tgz to ~/spacelock.tgz
# uncompress the bundle with `tar -zxf spacelock.tgz`
# if there already exists a 'spacelock' folder, remove it with `rm -rf ~/spacelock`
# rename the unbundled folder to 'spacelock' with `mv ~/bundle ~/spacelock`
# then do the following:

cd ~/spacelock;
rm -rf programs/server/node_modules;
rm -rf programs/server/npm;
ln -s ~/npmBuild/node_modules programs/server/node_modules;
ln -s ~/npmBuild/npm programs/server/npm;

# You'll have to repeat the first stage if you edit npm that have binaries

# FOR TESTING:
sudo service spacelock stop;
pkill node;
cd ~/spacelock;
MONGO_URL=mongodb://localhost:27017/spacelock PORT=80 ROOT_URL=http://spacelock2.local/ node main.js;

# FOR DEPLOY

# Add the following to `/etc/init.d/spacelock`

# you can simply run `reboot` to reboot (or `sudo reboot` if it fails)

#! /bin/sh
# /etc/init.d/spacelock

### BEGIN INIT INFO
# Provides:          spacelock
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Example initscript
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.
### END INIT INFO

# Carry out specific functions when asked to by the system
case "$1" in
   start)
    echo "Starting spacelock.js"
    service mongodb start;
    # run application you want to start
    PATH="$PATH:/usr/local/bin" MONGO_URL=mongodb://localhost:27017/spacelock PORT=80 ROOT_URL=http://spacelock2.local/ /usr/local/bin/forever -p /root/.forever start --minUptime 10000 --spinSleepTime 10000 --uid spacelock -a -s /root/spacelock/main.js;

   ;;
   stop)
    echo "Stopping spacelock.js"
    forever stop spacelock;
    ;;
  *)
    echo "Usage: /etc/init.d/spacelock {start|stop}"
    exit 1
    ;;
esac

exit 0

```