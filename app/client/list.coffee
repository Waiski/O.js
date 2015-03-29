Template.drinksList.helpers
  categories: ->
    Categories.find()

Template.drinkCategory.helpers
  drinks: ->
    search = Session.get 'search'
    Drinks.find {name: {$regex: search, $options:'i'},categoryId: @._id}, {sort: {name: 1}}

Template.drinkCategory.events
  'click .drink': ->
    Router.go 'drink', {slug: @.name}