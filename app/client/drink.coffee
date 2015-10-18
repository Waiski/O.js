Template.drinkTmpl.helpers
  getCategory: ->
    cat = Categories.findOne(@categoryId)
    if cat then cat.name else ""
  categories: ->
    Categories.find()

Template.drinkTmpl.rendered = ->
  # Set the select correctly
  @$('#drink-category-select').val(this.data.categoryId)

Template.drinkTmpl.events
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
    
Template.drinkOptionsDropdown.rendered = ->
  @$('.ui.dropdown').dropdown()

Template.drinkOptions.events
  'click #drink-edit': ->
    Session.set 'editMode', true
    edit = new share.Edit
    drink = Drinks.findOne( Session.get 'activeDrinkId' )
    edit.setOriginal drink
    Session.set 'edit', edit
  'click #edits-done': ->
    Session.set 'editMode', false
    edit = Session.get 'edit'
    unless Session.get 'addDrink'
      unless _.isEmpty edit.edits
        drink = Drinks.findOne( Session.get 'activeDrinkId' )
        redirect = false # If name is changed, then user must be redirected to the new address.
        _.each edit.edits, (oldAndNew, property) ->
          # Clear all attribute fields that will be repopulated by update reactivity
          $('.drink-property-set').filter('[data-drink-property="' + property + '"]')[0].innerHTML = "&zwnj;"
          # If the name has been edited, then redirect
          if not redirect and property is 'name' then redirect = true
        modifier = _.extend edit.setter(), edit.pusher()
        Drinks.update drink._id, modifier, ->
          if redirect then Router.go 'drink', slug: edit.edits.name.set
    else # Handle new drink add
      Session.set 'addDrink', false
      if _.isEmpty edit.edits
        Router.go 'home'
      else
        Drinks.insert edit.get(), (err, id) ->
          if not err then Meteor.call 'getDrinkName', id, (err, res) ->
            if not err
              Router.go 'drink', slug: res
              toastr.success 'Drink ' + res + ' added.'
  'click #drink-remove': ->
    $('#drink-delete-confirm-modal').modal
      onApprove: ->
        id = Session.get 'activeDrinkId'
        Router.go 'home'
        toastr.info 'Drink successfully removed.'
        Drinks.remove id
    .modal 'show'
