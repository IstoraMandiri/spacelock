@SpaceLock = @SpaceLock || {}

SpaceLock.cols =
    Logs: new Mongo.Collection 'Logs'
    Settings: new Mongo.Collection 'Settings'

# pub/sub

if Meteor.isServer

  userFields =
    'profile': 1
    'createdAt': 1

  SpaceLock.pubs =
    users: Meteor.publish 'users', -> Meteor.users.find({},{fields:userFields})


if Meteor.isClient

  SpaceLock.subs =
    users: Meteor.subscribe 'users'




# collection hooks

if Meteor.isServer
  Meteor.users.before.insert (userId, doc) ->
    name = doc.emails?[0].address || userId
    doc.profile = name: name
