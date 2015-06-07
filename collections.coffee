@SpaceLock = @SpaceLock || {}

SpaceLock.cols =
    Events: new Mongo.Collection 'Logs'
    Settings: new Mongo.Collection 'Settings'

# pub/sub
