Meteor.methods 'generateCard' : (userId) ->

  unless SpaceLock.adminAuth @userId
    throw new Meteor.Error 'Unauthorized'

  newCardId = Random.secret()

  SpaceLock.cols.Users.update userId,
    $set:
      hasCard: true
      _cardId: newCardId

  Roles.addUsersToRoles userId, 'cardEntry'


Meteor.methods 'destroyCard' : (userId) ->

  unless SpaceLock.adminAuth @userId
    throw new Meteor.Error 'Unauthorized'

  SpaceLock.cols.Users.update userId,
    $unset:
      hasCard: 1
      _cardId: 1

  Roles.removeUsersFromRoles userId, 'cardEntry'

Meteor.methods 'setCardId' : (options) ->

  unless SpaceLock.adminAuth @userId
    throw new Meteor.Error 'Unauthorized'

  if options.userId and options._cardId

    SpaceLock.cols.Users.update options.userId,
      $set:
        hasCard: true
        _cardId: options._cardId

    Roles.addUsersToRoles options.userId, 'cardEntry'
