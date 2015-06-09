
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


    console.log 'setting query to', JSON.stringify query, null, 2
    Meteor.users.find query, sort: createdAt: -1

Template.userViewer.events
  'keyup #searchUsers' : (e) ->
    Session.set 'userSearchFilter', e.currentTarget.value
