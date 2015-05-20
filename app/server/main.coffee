Meteor.startup ->
  # code to run on server at startup

Meteor.methods
  # Get the name of a drink without the need to subscribe to it
  # Remember to inclide auth check when accounts are implemented
  getDrinkName: (id) ->
    drink = Drinks.findOne(id)
    if drink then drink.name else undefined