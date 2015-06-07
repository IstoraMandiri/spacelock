# update the title reactively
Meteor.startup ->
  $title = $('head title')
  Deps.autorun ->
    $title.text SpaceLock.helpers.appContent()?.appTitle
