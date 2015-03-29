Template.drinksList.helpers
  categories: ->
    Categories.find()

Template.drinkCategory.helpers
  drinks: ->
    Drinks.find {categoryId: @._id}, {sort: {name: 1}}

Template.drinkCategory.events
  'click .drink': ->
    Session.set 'mainContentTransition', 'slideWindowLeft'
    Router.go 'drink', {slug: @.name}