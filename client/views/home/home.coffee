disabledColor = 'pink'

Template.home.events
  'click .unlock-door' : (e) ->
    $btn = $(e.currentTarget)
    unless $btn.hasClass disabledColor
      Meteor.call 'requestAccess', loginType: 'user'
      $btn.addClass disabledColor
      setTimeout ->
        $btn.removeClass disabledColor
      , 5000
