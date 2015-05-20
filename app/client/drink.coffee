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
  'blur .drink-property-set': (event, tmpl) ->
    edit = Session.get 'edit'
    self = $(event.target)
    property = self.data 'drink-property'
    value = if self.is 'select' then self.val() else self.text().trim()
    if value.length is 0 then self[0].innerHTML = "" # Remove unnecessary whitespace and html tags
    edit.add(property, value)
    Session.set 'edit', edit
  'keydown .drink-property-set': (event) ->
    if event.keyCode is 13
      event.target.blur()

Template.drinkManufacturer.helpers
  hasValidUrl: ->
    SimpleSchema.RegEx.Url.test(@website) or SimpleSchema.RegEx.Url.test('http://' + @website)
  getUrl: ->
    if SimpleSchema.RegEx.Url.test @website
      @website
    else if SimpleSchema.RegEx.Url.test('http://' + @website)
      'http://' + @website
    