Meteor.methods
  'requestAccess' : (options) ->

    # todo - modularize loginType section

    if options.loginType is 'user'
      # if logging in via meteor app, use the userId ...
      user = SpaceLock.cols.Users.findOne @userId
      unless user
        throw new Meteor.Error 'User Not Found'

      # todo check roles/permissions

    else if options.loginType is 'card'
      # throw an error if there's no _cardId, but card was specified
      unless options._cardId
        throw new Meteor.Error 'Card ID Not Provided'
      # ... otherwise, use the _cardId to find the user
      user = SpaceLock.cols.Users.findOne _cardId: options._cardId

      # todo check roles/permissions

      unless user
        # if a card was used but the user was not found, log the error
        SpaceLock.cols.Logs.insert
          type: 'invalidCard'
          data:
            _cardId: options._cardId
        # also throw to stop method
        throw new Meteor.Error 'Card is Invalid'

    else
      # loginType wasn't user or card
      throw new Meteor.Error 'Invalid Login Type'

    # decorate user info
    insertedUser =
      _id: user._id
      name: user.profile?.name

    if user._cardId
      insertedUser._cardId = user._cardId


    # authentication passed
    SpaceLock.cols.Logs.insert
      type: 'openDoor'
      data:
        method: options.loginType
        user: insertedUser

    # TODO refactor / secure
    if options.unlockTime and Roles.userIsInRole user, 'admin'
      unlockTime = options.unlockTime

    # actually open the door
    console.log "opening door for #{insertedUser.name} !"
    SpaceLock.door.unlock unlockTime

    return true
