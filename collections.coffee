@SpaceLock = @SpaceLock || {}

SpaceLock.cols =
    Users: Meteor.users
    Settings: new Mongo.Collection 'Settings'
    Logs: new Mongo.Collection 'Logs'

    Images: new FS.Collection 'Images',
      filter:
        allow: { contentTypes: ['image/*'] }
      stores: [
        new FS.Store.GridFS "images",
          transformWrite: (fileObj, readStream, writeStream) ->
            w = 300
            h = 300
            fileObj.extension('jpeg', {store: "images"})
            fileObj.type('image/jpeg', {store: "images"})
            gm(readStream, fileObj.name())
            .autoOrient()
            .resize(w, h, "^")
            .gravity('Center')
            .background("#FFF")
            .extent("#{w}","#{h}")
            .gravity('North')
            .crop(w, h)
            .quality(80)
            .stream('JPEG')
            .pipe(writeStream);
      ]




# allow/deny
for key, col of SpaceLock.cols

  # todo, secure properly
  if key is 'Images'
    col.allow
      insert: -> true
      update: -> true
      remove: -> true
      download: -> true

  else
    col.allow
      insert: -> true
      update: -> true
      remove: -> true

# pub/sub

if Meteor.isServer

  userFields =
    'profile': 1
    'createdAt': 1

  SpaceLock.pubs =
    Logs: Meteor.publish 'Logs', -> SpaceLock.cols.Logs.find()
    Settings: Meteor.publish 'Settings', -> SpaceLock.cols.Settings.find()
    Users: Meteor.publish 'Users', -> SpaceLock.cols.Users.find({},{fields:userFields})
    Images: Meteor.publish 'Images', -> SpaceLock.cols.Images.find()

if Meteor.isClient

  SpaceLock.subs =
    Logs: Meteor.subscribe 'Logs'
    Settings: Meteor.subscribe 'Settings'
    Users: Meteor.subscribe 'Users'
    Images: Meteor.subscribe 'Images'


# collection hooks
if Meteor.isServer

  SpaceLock.cols.Users.before.insert (userId, doc) ->
    name = doc.emails?[0].address || userId
    doc.profile = name: name

  SpaceLock.cols.Logs.before.insert (userId, doc) ->
    doc.createdAt = new Date()
