Template.drinkTmpl.helpers
  getSize: ->
    width = Session.get 'viewportWidth' # This is set in main.coffee
    if width > 1000
      [0.6 * width,undefined] 
    else if width > 800
      [0.8 * width,undefined]
    else 
      [width,undefined]

Template.drinkPropertySheet.helpers
  getCategory: ->
    cat = Categories.findOne(@categoryId)
    if cat then cat.name else ""
  categories: ->
    Categories.find()

Template.drinkPropertySheet.rendered = ->
  # Set the select correctly
  @$('#drink-category-select').val(this.data.categoryId)

Template.drinkPropertySheet.events
  'blur .drink-property': (event, tmpl) ->
    edit = Session.get 'edit'
    self = $(event.target)
    property = self.data 'drink-property'
    value = if self.is 'select' then self.val() else self.text()
    edit.add(property, value)
    Session.set 'edit', edit
  # Set the corresponding diplay element to selected value
  'change select.drink-property': (event, tmpl) ->
    self = $(event.target)
    textVal = self.children('[value="' + self.val() + '"]').text()
    Template.instance().$('.drink-property-display').filter('[data-drink-property="' + self.data('drink-property') + '"]').html textVal
  'keydown .drink-property': (event) ->
    if event.keyCode is 13
      event.target.blur()