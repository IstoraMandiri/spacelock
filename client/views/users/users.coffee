
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

    Meteor.users.find query, sort: createdAt: -1

Template.userViewer.events
  'keyup #searchUsers' : (e) ->
    Session.set 'userSearchFilter', e.currentTarget.value
