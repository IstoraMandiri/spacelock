Template.logViewer.helpers
  logs: ->
    SpaceLock.cols.Logs.find()

Template.logs.events
  'click .delete-all' : ->
    Meteor.call 'clearLogs'
