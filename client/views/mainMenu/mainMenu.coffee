Template.mainMenu.rendered = ->
  $(".button-collapse").sideNav({closeOnClick:true});
  $(".dropdown-button").dropdown();


Template.mainMenuItems.events
  'click .logout' : -> Meteor.logout()
