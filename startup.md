# special startup script for raspberry pi bnundle

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

sudo MONGO_URL=mongodb://localhost:27017/spacelock PORT=3000 ROOT_URL=http://192.168.1.4/ node main.js;
