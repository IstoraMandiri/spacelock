Template.settingsSubmenu.helpers
  settingsOptions: ->
    currentRoute = SpaceLock.helpers.currentRouteName()
    return _.map SpaceLock.routes.settings, (obj) ->
      obj.fullname = "settings.#{obj.name}"
      obj.active = obj.fullname is currentRoute
      return obj
