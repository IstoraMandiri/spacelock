Template.user.events
  'change .update-field' : (e) ->
    key = $(e.currentTarget).attr('name')
    value = e.currentTarget.value
    update = {$set:{}}

    update.$set[key] = value

    SpaceLock.cols.Users.update @_id, update

  'change .image-upload-input' : (e) ->
    file = e.target.files[0]
    file._userId = @_id
    if @profile.image
      SpaceLock.cols.Images.remove @profile.image
    fileObj = SpaceLock.cols.Images.insert file
    SpaceLock.cols.Users.update @_id, $set: 'profile.image': fileObj._id

  'change .toggle-role' : (e) ->
    $target = $(e.currentTarget)
    role = $target.attr('name')
    isEnabled = $target.is(':checked')
    if isEnabled
      Roles.addUsersToRoles @userId, role
    else
      Roles.removeUsersFromRoles @userId, role

  'click .generate-card' : -> Meteor.call 'generateCard', @_id

  'click .destroy-card' : -> Meteor.call 'destroyCard', @_id

  'click .set-card' : ->
    if _cardId = prompt 'Enter Card Id'
      Meteor.call 'setCardId', { userId: @_id, _cardId: _cardId}, (err,res) ->
        alert err || "Card set to: #{_cardId}"

  'click .set-password' : ->
    if password = prompt 'Set new password (min 6 chars)'
      Meteor.call 'setUserPassword', { userId: @_id, password: password}, (err, res) ->
        alert err || "Password reset."



Template.user.helpers
  configurableRoles: ->
    userId = @_id

    [
      text: 'Allow Card Entry'
      role: 'cardEntry'
    ,
      text: 'Allow Entry using App'
      role: 'appEntry'
    ,
      text: 'Admin Access'
      role: 'admin'
    ].map (obj, i) ->
      obj.i = i
      obj.hasRole = Roles.userIsInRole userId, obj.role
      obj.userId = userId
      return obj
