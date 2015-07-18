Template.logs.events
  'click .delete-all' : ->
    Meteor.call 'clearLogs'

Template.logViewer.rendered = ->
  Session.set 'logSearchFilter', false
  Session.set 'logStartFilter', false
  Session.set 'logEndFilter', false


Template.logViewer.helpers
  logs: ->
    searchFilter = Session.get 'logSearchFilter'
    startFilter = Session.get 'logStartFilter'
    endFilter = Session.get 'logEndFilter'

    query = {}

    if searchFilter

      query['$or'] = [
        'data.user.name':
          $regex: searchFilter
          $options: 'i'
      ]

    if startFilter or endFilter
      query['createdAt'] = {}

    if startFilter
      query['createdAt']['$gt'] = new Date(startFilter)

    if endFilter
      query['createdAt']['$lt'] = new Date(endFilter)

    SpaceLock.cols.Logs.find query, sort: createdAt: -1


Template.logViewer.events
  'keyup #searchLogs' : (e) ->
    Session.set 'logSearchFilter', e.currentTarget.value
  'change #startDate' : (e) ->
    Session.set 'logStartFilter', e.currentTarget.value
  'change #endDate' : (e) ->
    Session.set 'logEndFilter', e.currentTarget.value
