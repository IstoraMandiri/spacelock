# special startup script for raspberry pi bnundle

# For the first build, do this:

sudo apt-get install libudev-dev;

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

# After that build, move it and symlink it so it doesn't get overwritten

mkdir ~/npmBuild/;
cp -R programs/server/node_modules ~/npmBuild/node_modules;
cp -R programs/server/npm ~/npmBuild/npm;

# From then on, you can simply do the below to relink the npm build instead of rebuilding it each time

rm -rf programs/server/node_modules;
rm -rf programs/server/npm;
ln -s ~/npmBuild/node_modules programs/server/node_modules;
ln -s ~/npmBuild/npm programs/server/npm;

# You'll have to repeat the first stage if you edit npm that have binaries


sudo MONGO_URL=mongodb://localhost:27017/spacelock PORT=3000 ROOT_URL=http://192.168.1.8/ node main.js;
