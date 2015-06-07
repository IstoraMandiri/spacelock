@SpaceLock = @SpaceLock || {}

SpaceLock.cols =
    Events: new Mongo.Collection 'Logs'
    Cards: new Mongo.Collection 'Cards'
    Settings: new Mongo.Collection 'Settings'

# pub/sub
