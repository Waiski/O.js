Template.userTabsModal.helpers
  recentUsers: ->
    notabbers = Roles.getUsersInRole('notabber').map (user) -> user._id 
    Meteor.users.find {_id: $nin: notabbers}, {sort: {lastActive: -1}, limit: 10}
  users: ->
    notabbers = Roles.getUsersInRole('notabber').map (user) -> user._id 
    Meteor.users.find {_id: $nin: notabbers}, sort: username: 1

Template.tabCard.onRendered ->
  @$('.user-tab-card').click ->
    console.log 'Vittu.'
