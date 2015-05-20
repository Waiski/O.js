Template.drinksList.helpers
  categories: ->
    Categories.find()
  getLeftBarSize: ->
    width = Session.get 'viewportWidth'
    if width > 1000
        [0.2 * width,undefined]
    else if width > 800
        [0.3 * width,undefined]
    else 
        [0,undefined]
  getMainSize: ->
    width = Session.get 'viewportWidth'
    if width > 1000
        [600,undefined] 
    else if width > 800
        [0.7 * width,undefined]
    else 
        [width,undefined]

Template.drinkCategory.helpers
  drinks: ->
    search = Session.get 'search'
    Drinks.find {name: {$regex: search, $options:'i'},categoryId: @._id}, {sort: {name: 1}}