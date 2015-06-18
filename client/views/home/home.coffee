disabledColor = 'pink'

# todo convert this jquery disabled color to reactive class once we have door collection

Template.home.events
  'click .unlock-door' : (e) ->
    $btn = $(event.target)
    unless $btn.hasClass disabledColor
      Meteor.call 'requestAccess', loginType: 'user'
      $btn.addClass disabledColor
      setTimeout ->
        $btn.removeClass disabledColor
      , SpaceLock.helpers.mainConfig().door.openTime

  'click .timed-unlock-door' : (event,template) ->
    $btn = $(event.target)
    unlockTime = parseInt(prompt('How long? Seconds'))
    if unlockTime > 1
      unlockTime = unlockTime * 1000
      unless $btn.hasClass disabledColor
        Meteor.call 'requestAccess',
          loginType: 'user'
          unlockTime: unlockTime

        $btn.addClass disabledColor
        Meteor.setTimeout ->
          $btn.removeClass disabledColor
        , unlockTime

