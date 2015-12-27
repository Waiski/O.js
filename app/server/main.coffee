Meteor.startup ->
  # code to run on server at startup
  if Meteor.users.find().count() is 0
    # Add a default user
    adminId = Accounts.createUser
      username: 'admin'
      password: 'adminsalasanaonihansikavahva'
      email: 'valtter@vihervuori.fi'
      profile:
        name: 'Administrator'
  

Meteor.methods
  # Get the name of a drink without the need to subscribe to it
  # Remember to include auth check when accounts are implemented
  getDrinkName: (id) ->
    drink = Drinks.findOne(id)
    if drink then drink.name else undefined
  inviteUser: (data) ->
    data.password = Random.id(10)
    data.profile = {}
    id = Accounts.createUser data
    data.password
