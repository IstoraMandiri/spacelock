Meteor.methods
  'setUserPassword': (options={}) ->
    # allow admins to change anyone or users to change themselves
    if SpaceLock.adminAuth(@userId) or options.userId is @userId
      logout = options.userId isnt @userId
      Accounts.setPassword options.userId, options.password, logout: logout
    else
      new Meteor.error 'Unauthorized'