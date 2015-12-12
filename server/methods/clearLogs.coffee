Meteor.methods
  'clearLogs' : ->

    unless SpaceLock.adminAuth @userId
      throw new Meteor.Error 'Unauthorized'

    SpaceLock.cols.Logs.remove({})
