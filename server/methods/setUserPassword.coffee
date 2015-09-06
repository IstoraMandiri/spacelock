Meteor.methods
  'setUserPassword': (options={}) ->
    if SpaceLock.adminAuth @userId
      Accounts.setPassword options.userId, options.password
    else
      new Meteor.error 'Unauthorized'