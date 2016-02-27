Template.drinksList.onRendered ->
  # Maybe someday CSS position: sticky will work in all browsers
  # But for now this requires JS 
  @$('.ui.sticky').sticky
    context: '#drinks-list'

Template.drinksList.helpers
  categories: ->
    Categories.find {}, sort: order: 1

Template.drinkCategory.helpers
  drinks: ->
    search = Session.get 'search'
    Drinks.find {nameSearchable: {$regex: search, $options:'i'}, categoryId: @._id}, {sort: {name: 1}}
