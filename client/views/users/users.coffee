
Template.userViewer.rendered = ->
  Session.set 'userSearchFilter', false

Template.userViewer.helpers
  users: ->
    searchFilter = Session.get 'userSearchFilter'

    query = {}

    if searchFilter

      query = $or: [
        'profile.name':
          $regex: searchFilter
          $options: 'i'
      # ,
      #   'profile.description':
      #     $regex: searchFilter
      #     $options: 'i'
      ]

    SpaceLock.cols.Users.find query, sort: createdAt: -1

  doorsOpened : -> SpaceLock.cols.Logs.find({ type: 'openDoor', 'data.user._id': @_id }).count()
  latestLogin : -> SpaceLock.cols.Logs.findOne({ type: 'openDoor', 'data.user._id': @_id }, { sort: { createdAt: -1 }})?.createdAt


Template.userViewer.events
  'keyup #searchUsers' : (e) ->
    Session.set 'userSearchFilter', e.currentTarget.value
