Template.userViewer.helpers
  users: ->
    Meteor.users.find {}, sort: createdAt: -1
