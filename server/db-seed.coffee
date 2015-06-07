Meteor.startup ->
  if SpaceLock.cols.Settings.find({_id: 'main'}).count() is 0
    console.log 'no main config found, seeding database'

    mainConfig =
      _id: 'main'
      content:
        'appTitle' : "SpaceLock"
        'home' : "No messages right now."
        'signIn' : "Welcome to the app. You must log in to continue."
        'footer' : """
          <h5 class="white-text">Company Bio</h5>
          <p class="grey-text text-lighten-4">We are a team of college students working on this project like it's our full time job. Any amount would help support and continue development on this project and is greatly appreciated.</p>
        """

    SpaceLock.cols.Settings.insert mainConfig
