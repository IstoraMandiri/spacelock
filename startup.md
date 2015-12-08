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

# IF YOU HAVE ALREDY BUILT, from then on, you can simply do the below to relink the npm build instead of rebuilding it each time

rm -rf programs/server/node_modules;
rm -rf programs/server/npm;
ln -s ~/npmBuild/node_modules programs/server/node_modules;
ln -s ~/npmBuild/npm programs/server/npm;


ln -s /sys/devices/virtual/gpio /sys/class/gpio

# You'll have to repeat the first stage if you edit npm that have binaries


# FOR TESTING:
cd ~/spacelock;
MONGO_URL=mongodb://localhost:27017/spacelock PORT=80 ROOT_URL=http://spacelock.local/ node main.js;

# FOR DEPLOY

# Add the following to `/etc/init.d/spacelock`

TODO: ADD startup script
