Template.logViewer.helpers
  logs: ->
    SpaceLock.cols.Logs.find {}, sort: createdAt: -1


Template.logs.events
  'click .delete-all' : ->
    Meteor.call 'clearLogs'
