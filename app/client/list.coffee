Template.drinksList.helpers
  categories: ->
    Categories.find()

Template.drinkCategory.helpers
  drinks: ->
    Drinks.find {categoryId: @._id}, {sort: {name: 1}}