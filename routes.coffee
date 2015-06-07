Router.configure
  layoutTemplate: "mainLayout"
  loadingTemplate: "loading"
  onBeforeAction: ->
    if Meteor.user()
      @next()
    else if @route.getName() isnt 'sign-in'
      @redirect 'sign-in'
    else
      @render 'sign-in'

Router.route '/', ->
  @render 'home'
,
  name: 'home'

Router.route 'sign-in'

Router.route 'logs'

Router.route 'settings'

Router.route 'users'
