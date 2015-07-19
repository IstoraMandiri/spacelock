Meteor.methods 'generateCard' : (userId) ->
  newCardId = Random.secret()

  SpaceLock.cols.Users.update userId,
    $set:
      hasCard: true
      _cardId: newCardId

  Roles.addUsersToRoles userId, 'cardEntry'


Meteor.methods 'destroyCard' : (userId) ->

  SpaceLock.cols.Users.update userId,
    $unset:
      hasCard: 1
      _cardId: 1

  Roles.removeUsersFromRoles userId, 'cardEntry'

Meteor.methods 'setCardId' : (options) ->
  if options.userId and options._cardId

    SpaceLock.cols.Users.update options.userId,
      $set:
        hasCard: true
        _cardId: options._cardId

    Roles.addUsersToRoles options.userId, 'cardEntry'
