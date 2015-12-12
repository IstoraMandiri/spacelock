Template.logs.events
  'click .delete-all' : ->
    if confirm "Are you sure you wish to delete all logs?"
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

  profileImage: ->
    SpaceLock.cols.Users.findOne(@data.user._id)?.profile.image

  eventIcon: ->
    if @type is 'openDoor'
      'unlock'
    else if @type is 'invalidCard'
      'times'
    else if @type is 'noAppPermission' \
    or @type is 'noCardPermission'
      'user-times'

    # else if

  methodIcon: ->
    if @data.method is 'user'
      'mobile'
    else if @data.method is 'card'
      'credit-card-alt'

  rowColor: ->
    if @direction is 'exit'
      'lime lighten-5'
    # else if @direction is 'exit'
    #   'red lighten-5'

  directionIcon: ->
    if @direction is 'enter'
      'arrow-left'
    else if @direction is 'exit'
      'arrow-right'


Template.logViewer.events
  'keyup #searchLogs' : (e) ->
    Session.set 'logSearchFilter', e.currentTarget.value
  'change #startDate' : (e) ->
    Session.set 'logStartFilter', e.currentTarget.value
  'change #endDate' : (e) ->
    Session.set 'logEndFilter', e.currentTarget.value
