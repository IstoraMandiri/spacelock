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
