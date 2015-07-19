@SpaceLock = @SpaceLock || {}

SpaceLock.cols =
    Users: Meteor.users
    Roles: Meteor.roles
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


adminAuth = (userId) -> Roles.userIsInRole userId, 'admin'
userAuth = (userId) -> userId
# allow/deny
for key, col of SpaceLock.cols


  # todo, secure properly
  if key is 'Images'
    col.allow
      insert: adminAuth
      update: adminAuth
      remove: adminAuth
      download: -> true

  else
    col.allow
      insert: adminAuth
      update: adminAuth
      remove: adminAuth

# pub/sub

if Meteor.isServer

  SpaceLock.pubs =

    Logs: Meteor.publish 'Logs', ->
      if adminAuth @userId then SpaceLock.cols.Logs.find()

    # TODO
    Settings: Meteor.publish 'Settings', ->
      SpaceLock.cols.Settings.find()

    Roles: Meteor.publish 'Roles', ->
      if userAuth @userId then SpaceLock.cols.Roles.find()

    Images: Meteor.publish 'Images', ->
      if adminAuth @userId then SpaceLock.cols.Images.find()

    Users: Meteor.publish 'Users', ->
      if userAuth @userId
        query = if adminAuth @userId then {} else _id: @userId
        SpaceLock.cols.Users.find query,
          fields: { profile: 1, createdAt: 1, hasCard: 1, roles:1 }


if Meteor.isClient

  SpaceLock.subs =
    Logs: Meteor.subscribe 'Logs'
    Roles: Meteor.subscribe 'Roles'
    Settings: Meteor.subscribe 'Settings'
    Images: Meteor.subscribe 'Images'
    Users: Meteor.subscribe 'Users'


# collection hooks
if Meteor.isServer

  SpaceLock.cols.Users.before.insert (userId, doc) ->
    name = doc.emails?[0].address || userId
    doc.profile = name: name

  SpaceLock.cols.Logs.before.insert (userId, doc) ->
    doc.createdAt = new Date()
