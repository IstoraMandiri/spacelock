Meteor.methods
  'requestAccess' : (options) ->
    # todo - modularize loginType section

    if options.loginType is 'user'
      # if logging in via meteor app, use the userId ...
      user = SpaceLock.cols.Users.findOne @userId
      unless user
        throw new Meteor.Error 'User Not Found'

      # check allow app entry permissions
      unless Roles.userIsInRole @userId, 'appEntry'
        # log the error
        SpaceLock.cols.Logs.insert
          type: 'noAppPermission'
          data:
            user:
              _id: user._id
              name: user.profile?.name
        # stop the method
        throw new Meteor.Error 'User does not have permission to enter via app'

    else if options.loginType is 'card'
      # check that it's not being called by a client
      unless this.connection is null
        throw new Meteor.Error "RED ALERT, HACK ATTEMPT!"
      # throw an error if there's no _cardId, but card was specified
      unless options._cardId
        throw new Meteor.Error 'Card ID Not Provided'
      # ... otherwise, use the _cardId to find the user
      user = SpaceLock.cols.Users.findOne _cardId: options._cardId


      unless user
        # if a card was used but the user was not found, log the error
        SpaceLock.cols.Logs.insert
          type: 'invalidCard'
          data:
            _cardId: options._cardId
        # also throw to stop method
        throw new Meteor.Error 'Card is invalid'

      # check allow card entry permissions
      unless Roles.userIsInRole user._id, 'cardEntry'
        # log the error
        SpaceLock.cols.Logs.insert
          type: 'noCardPermission'
          data:
            _cardId: options._cardId
            user:
              _id: user._id
              name: user.profile?.name

        # also throw to stop method
        throw new Meteor.Error 'User does not have permission to enter via app'

    else
      # loginType wasn't user or card
      throw new Meteor.Error 'Invalid Login Type'

    # authentication passed

    # decorate user info
    insertedUser =
      _id: user._id
      name: user.profile?.name

    if user._cardId
      insertedUser._cardId = user._cardId

    # get previous entries, sorted by earliest
    if options.direction is 'exit'
      previousEntriesQuery =
        'data.user._id': user._id
        'exitEventId' : {$exists: false}
        'direction' : 'enter'
      unExitedEntries = SpaceLock.cols.Logs.find(previousEntriesQuery, {$sort:createdAt: 1}).fetch()
    else
      unExitedEntries = []

    # logging
    log =
      type: 'openDoor'
      data:
        method: options.loginType
        user: insertedUser

    # add direction if relevent
    if options.direction
      log.direction = options.direction

    # if there are previous unexited entries, find the earliest
    # check how long has passed since that entry
    # add that time difference to this log
    if unExitedEntries[0]?
      # this is the oldest time
      log.timeSpentInside = new Date() - unExitedEntries[0].createdAt

    # add entry ids
    if unExitedEntries.length
      log.entryIds = _.map unExitedEntries, (entry) -> entry._id

    logId = SpaceLock.cols.Logs.insert log

    # if it's an exit, let's update all other entries with this ID for exitring
    # update the old entries with a reference to this logId
    for entryLog in unExitedEntries
      SpaceLock.cols.Logs.update entryLog._id, $set: exitEventId: logId

    if options.unlockTime and Roles.userIsInRole user, 'admin'
      unlockTime = options.unlockTime

    # actually open the door
    SpaceLock.door.unlock unlockTime

    return true
