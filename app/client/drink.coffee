Template.drink.helpers
  getSize: ->
    width = Session.get 'viewportWidth' # This is set in main.coffee
    if width > 1000
      [0.6 * width,undefined] 
    else if width > 800
      [0.8 * width,undefined]
    else 
      [width,undefined]

Template.drinkPropertySheet.events
  'blur .drink-property': (event, tmpl) ->
    property = $(event.target).data 'drink-property'
    value = $(event.target).text()
    setter = $set: {}
    setter.$set[property] = value
    if value isnt this[property]
      event.target.innerHTML = "" # The content will be repopulated by Meteor reactivity
    # 'this' (@ in Coffee) contains the current data context (the drink)
    Drinks.update @_id, setter
    if property is 'name'
      Router.go 'drink', slug: value
  'keydown .drink-property': (event) ->
    if event.keyCode is 13
      event.target.blur()