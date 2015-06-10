# exports
@SpaceLock = @SpaceLock || {}

@SpaceLock.routes =

  main: [
    title: 'Home'
    name: 'home'
    path: '/'
  ,
    title: 'Logs'
    name: 'logs'
    path: '/logs'
    adminOnly: true
  ,
    title: 'Users'
    name: 'users'
    path: '/users'
    adminOnly: true
  ,
    title: 'Settings'
    name: 'settings'
    path: '/settings'
    adminOnly: true
  ]

  settings: [
    title: 'Content'
    name: 'content'
  ,
    title: 'Social'
    name: 'social'
  ,
    title: 'Door'
    name: 'door'
  ]

# global route config
Router.configure
  layoutTemplate: "mainLayout"
  loadingTemplate: "loading"
  onBeforeAction: ->
    if Meteor.loggingIn()
      @render 'loading'
    else if Meteor.user()
      @next()
    # TODO redirect if not admin
    else if @route.getName() isnt 'sign-in'
      @redirect 'sign-in'
    else
      @render 'sign-in'

# build main menu routes
for route in SpaceLock.routes.main
  if route.name is 'settings'
    Router.route route.path,
      name: route.name
      action: -> @redirect '/settings/content'
  else
    Router.route route.path,
      name: route.name

# user route
Router.route '/users/:_userId', ->
  @render 'user',
    data: -> SpaceLock.cols.Users.findOne @params._userId
,
  name: 'user'


# sign in route
Router.route '/sign-in', ->
  if Meteor.user()
    @redirect '/'
  else
    @render 'sign-in'


# build settings submenu routes
SettingsController = RouteController.extend
  action: ->
    @render 'settings'
    @render @route.getName(), to: 'subsection'

for settingsRoute in SpaceLock.routes.settings
  Router.route "/settings/#{settingsRoute.name}", controller: SettingsController
