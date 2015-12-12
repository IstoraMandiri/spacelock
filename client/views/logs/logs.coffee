Template.logs.events
  'click .delete-all' : ->
    if confirm "Are you sure you wish to delete all logs?"
      Meteor.call 'clearLogs'

Template.logViewer.onCreated ->
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

Template.logsTable.helpers

  profileImage: ->
    SpaceLock.cols.Users.findOne(@data.user._id)?.profile.image

  eventIcon: ->
    if @type is 'openDoor'
      'action-lock-open'
    else if @type is 'invalidCard'
      'content-clear'
    else if @type is 'noAppPermission' \
    or @type is 'noCardPermission'
      'content-block'

    # else if

  methodIcon: ->
    if @data.method is 'user'
      'hardware-phone-android'
    else if @data.method is 'card'
      'action-payment'

  rowColor: ->
    if @direction is 'exit'
      'cyan lighten-5'

  directionIcon: ->
    if @direction is 'enter'
      'communication-call-received'
    else if @direction is 'exit'
      'communication-call-made'


Template.logViewer.events
  'keyup #searchLogs' : (e) ->
    Session.set 'logSearchFilter', e.currentTarget.value
  'change #startDate' : (e) ->
    Session.set 'logStartFilter', e.currentTarget.value
  'change #endDate' : (e) ->
    Session.set 'logEndFilter', e.currentTarget.value
