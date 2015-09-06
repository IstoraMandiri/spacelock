disabledColor = 'pink'

Session.set 'entryDisabled'

needToExit = ->
  lastOpenEvent = SpaceLock.cols.Logs.findOne
    'type':'openDoor'
    'data.user._id': Meteor.userId()
    'unlockTime' : $exists: false
  ,
    sort: createdAt: -1

  return lastOpenEvent and lastOpenEvent.direction isnt 'exit'


Template.home.events
  'click .unlock-door' : (e) ->
    unless Session.get 'entryDisabled'
      $btn = $(event.target)
      Meteor.call 'requestAccess',
        loginType: 'user'
        direction: if needToExit() then 'exit' else 'enter'

      Session.set 'entryDisabled', true
      setTimeout ->
        Session.set 'entryDisabled', false
      , SpaceLock.helpers.mainConfig().door.openTime

  'click .timed-unlock-door' : (event,template) ->
    unless Session.get 'entryDisabled'
      $btn = $(event.target)
      unlockTime = parseInt(prompt('How long? Seconds'))
      if unlockTime > 1
        unlockTime = unlockTime * 1000
        Meteor.call 'requestAccess',
          loginType: 'user'
          unlockTime: unlockTime

        Session.set 'entryDisabled', true
        Meteor.setTimeout ->
          Session.set 'entryDisabled', false
        , unlockTime

Template.home.helpers
  'needToExit' : needToExit
  'entryDisabled' : -> Session.get 'entryDisabled'
