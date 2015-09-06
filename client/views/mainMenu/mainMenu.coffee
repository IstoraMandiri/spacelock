Template.mainMenu.rendered = ->
  $(".button-collapse").sideNav({closeOnClick:true});
  $(".dropdown-button").dropdown();

Template.mainMenuItems.helpers
  menuItems: ->
    currentRoute = SpaceLock.helpers.currentRouteName()
    isAdmin = Roles.userIsInRole Meteor.user(), 'admin'
    filteredRoutes = _.filter SpaceLock.routes.main, (route) ->
      isAdmin or !route.adminOnly
    return _.map filteredRoutes, (obj) ->
      obj.active = currentRoute.indexOf(obj.name) is 0
      return obj

Template.mainMenuItems.events
  'click .logout' : ->
    if confirm "Really Logout?"
      Meteor.logout()
