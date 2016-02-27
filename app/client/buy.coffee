Template.userTabsModal.helpers
  recentUsers: ->
    notabbers = Roles.getUsersInRole('notabber').map (user) -> user._id 
    Meteor.users.find {_id: $nin: notabbers}, {sort: {lastActive: -1}, limit: 10}
  users: ->
    notabbers = Roles.getUsersInRole('notabber').map (user) -> user._id 
    Meteor.users.find {_id: $nin: notabbers}, sort: username: 1

Template.userTabsModal.onCreated ->
  # Reset so that any old values are unset
  Session.set 'drinkBeingBought', undefined

Template.tabCard.onRendered ->
  id = @data._id
  @$('.user-tab-card').click ->
    # Remember to set this when opening the modal
    drink = Drinks.findOne Session.get 'drinkBeingBought'
    if not drink then return console.error 'Drink not found!'
    Transactions.insert
      userId: id
      amount: drink.price
      drink:
        id: drink._id
        name: drink.name
      , (err) ->
        if err
          toastr.error err.message
        else
          toastr.success 'Drink successfully bought'
