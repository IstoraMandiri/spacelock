

contentFields = [
  title: 'App Title'
  name: 'appTitle'
,
  title: 'Welcome Page'
  name: 'home'
,
  title: 'Sign In Page'
  name: 'signIn'
,
  title: 'Footer'
  name: 'footer'
]

Template.settingsContent.helpers
  contentFields: ->
    appContent = SpaceLock.helpers.appContent()
    return contentFields.map (obj, i) ->
      obj.value = appContent[obj.name]
      obj.i = i
      return obj

Template.settingsContent.events
  'change textarea': (e) ->
    update = {}
    update["content.#{@name}"] = e.currentTarget.value
    SpaceLock.cols.Settings.update 'main', $set: update
