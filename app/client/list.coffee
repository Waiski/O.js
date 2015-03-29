Template.drinksList.helpers
  drinks: ->
    Drinks.find {}, {sort: {name: 1}}
  categories: ->
    Categories.find()