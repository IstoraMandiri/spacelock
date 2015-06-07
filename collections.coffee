@SpaceLock = @SpaceLock || {}

SpaceLock.cols =
    Logs: new Mongo.Collection 'Logs'
    Settings: new Mongo.Collection 'Settings'

# pub/sub
