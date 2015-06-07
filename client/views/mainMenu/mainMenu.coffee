Template.mainMenu.rendered = ->
  $(".button-collapse").sideNav({closeOnClick:true});
  $(".dropdown-button").dropdown();

Template.mainMenuItems.helpers
  menuItems: ->
    currentRoute = SpaceLock.helpers.currentRouteName()
    return _.map SpaceLock.routes.main, (obj) ->
      obj.active = currentRoute.indexOf(obj.name) is 0
      return obj

Template.mainMenuItems.events
  'click .logout' : -> Meteor.logout()
