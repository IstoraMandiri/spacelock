# special startup script for raspberry pi bnundle
# TODO add usb node installation

sudo apt-get install libudev-dev;

sudo rm -r programs/server/node_modules/fibers;
sudo rm -r programs/server/node_modules/bcrypt;
sudo rm -r programs/server/npm/npm-bcrypt;
sudo rm -r programs/server/npm/cfs_gridfs/node_modules/mongodb/node_modules/;
cd programs/server;

npm install fibers@1.0.1 bcrypt@0.7.7;
cd npm/cfs_gridfs/node_modules/mongodb;
npm install bson;
cd ../../../../;
cd ../../;
MONGO_URL=mongodb://localhost:27017/spacelock PORT=3000 ROOT_URL=http://192.168.1.4/ node main.js;
