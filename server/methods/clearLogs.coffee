Meteor.methods
  'clearLogs' : ->
    console.log 'clearing all logs'
    SpaceLock.cols.Logs.remove({})
