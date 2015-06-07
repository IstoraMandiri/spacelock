Meteor.startup ->
  if SpaceLock.cols.Settings.find({_id: 'main'}).count() is 0

    console.log 'no main config found, seeding database'

    defaultConfig =

      _id: "main"

      content:
        appTitle: "SpaceLock"
        home: "No messages right now."
        signIn: "Welcome to the app. Please log in to continue."
        footer: "<h5 class='white-text'>Company Bio</h5>"

      door:
        openTime: 5 * 1000 # 5 seonds

      social:
        twitter:
          throttle: 5 # max tweets per 10 minutes
          apiKey: 'xxx'
          message: 'Someone has come in!'


    SpaceLock.cols.Settings.insert defaultConfig
