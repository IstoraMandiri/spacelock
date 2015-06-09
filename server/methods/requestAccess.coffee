insertLog = (options) ->
  options.createdAt = new Date()
  SpaceLock.cols.Logs.insert options

Meteor.methods
  'requestAccess' : (options) ->

    if options.loginType is 'user'
      # if logging in via meteor app, use the userId ...
      user = Meteor.users.findOne @userId
      unless user
        throw new Meteor.Error 'User Not Found'

      # todo check roles/permissions

    else if options.loginType is 'card'
      # throw an error if there's no _cardId, but card was specified
      unless options._cardId
        throw new Meteor.Error 'Card ID Not Provided'
      # ... otherwise, use the _cardId to find the user
      user = Meteor.users.findOne _cardId: options._cardId

      # todo check roles/permissions

      unless user
        # if a card was used but the user was not found, log the error
        insertLog
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
    insertLog
      type: 'openDoor'
      data:
        method: options.loginType
        user: insertedUser

    # actually open the door
    console.log "opening door for #{insertedUser.name} !"
