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
      , (err, id) ->
        if err
          toastr.error err.message
        else
          # The second argument is the title, it has to be there for the options to work
          toast = toastr.success(
            'Drink successfully bought! <a class="undo">Undo</a>',
            '',
            timeOut: 15000
            )
          $('#tabs-modal').modal 'hide'
          
          toast.find('.undo').click ->
            Transactions.remove id, (err) ->
              if (err)
                toastr.error err.message
              else
                toastr.info 'Purchase undone.'
          # For undoing (TODO)
          Session.set 'lastTransactionId', id
