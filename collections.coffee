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


adminAuth = SpaceLock.adminAuth = (userId) -> Roles.userIsInRole userId, 'admin'
userAuth = SpaceLock.userAuth = (userId) -> userId
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

    # TODO
    Settings: Meteor.publish 'Settings', -> SpaceLock.cols.Settings.find()

    Logs: Meteor.publish 'Logs', (auth) ->
      if auth and adminAuth @userId
        return SpaceLock.cols.Logs.find()
      else
        return @stop()


    Roles: Meteor.publish 'Roles', (auth) ->
      if auth and userAuth @userId
        return SpaceLock.cols.Roles.find()
      else
        return @stop()


    Images: Meteor.publish 'Images', (auth) ->
      if auth and adminAuth @userId
        return SpaceLock.cols.Images.find()
      else
        return @stop()

    Users: Meteor.publish 'Users', (auth) ->
      if auth and userAuth @userId
        query = if adminAuth @userId then {} else _id: @userId
        SpaceLock.cols.Users.find query,
          fields: { profile: 1, createdAt: 1, hasCard: 1, roles:1, emails:1 }
      else
        return @stop()

if Meteor.isClient

  SpaceLock.subs = {}
  SpaceLock.subs.Settings = Meteor.subscribe 'Settings'

  Tracker.autorun ->
    isAdminAuthorized = adminAuth Meteor.userId()
    SpaceLock.subs.Logs = Meteor.subscribe 'Logs', isAdminAuthorized
    SpaceLock.subs.Roles = Meteor.subscribe 'Roles', isAdminAuthorized
    SpaceLock.subs.Images = Meteor.subscribe 'Images', isAdminAuthorized

  Tracker.autorun ->
    isUserAuthorized = userAuth Meteor.userId()
    SpaceLock.subs.Users = Meteor.subscribe 'Users', isUserAuthorized


# collection hooks
if Meteor.isServer

  SpaceLock.cols.Users.before.insert (userId, doc) ->
    name = doc.emails?[0].address || userId
    doc.profile = name: name

  SpaceLock.cols.Logs.before.insert (userId, doc) ->
    doc.createdAt = new Date()
