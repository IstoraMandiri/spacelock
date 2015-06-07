@Spacelock =
  cols:
    Events: new Mongo.Collection 'Logs'
    Cards: new Mongo.Collection 'Cards'
    Config: new Mongo.Collection 'Settings'

# pub/sub
