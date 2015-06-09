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
