currentDrinkId = undefined;

Template.drinkTmpl.helpers
  getCategory: ->
    cat = Categories.findOne(@categoryId)
    if cat then cat.name else ""
  categories: ->
    Categories.find()
  isSelected: (a, b) ->
    if a is b then 'selected' else ''
  drink: ->
    if @addition
      { properties: {} }
    else
      Drinks.findOne( currentDrinkId )

Template.drinkTmpl.created = ->
  unless @data.addition
    currentDrinkId = Drinks.findOne( name: @data.drinkName )._id
    if not currentDrinkId then Router.go 'home'

Template.drinkTmpl.rendered = ->
  @$('#drink-category-select').dropdown
    onChange: ->
      readEdit $(@)

  self = @
  unless @data and @data.addition
    @autorun ->
      drink = Drinks.findOne( Session.get 'activeDrinkId' )
      if not drink then return
      # Set the select correctly
      self.$('#drink-category-select').val(drink.categoryId)
      # Hide unset property labels when not in editmode
      self.$('.drink-detail-row').each (index, element) ->
        prop = $(element).find('.drink-property-set').data 'drink-property'
        if _.isEmpty(drink.properties[prop])
          $(element).addClass 'hidden-normally'
        else
          $(element).removeClass 'hidden-normally'

readEdit = (element) ->
  edit = Session.get 'edit'
  property = element.data 'drink-property'
  if not property then return
  value = if element.is 'select' then element.val() else element.text().trim()
  # Remove unnecessary whitespace and html tags
  if value.length is 0 then element[0].innerHTML = ""
  edit.add(property, value)
  Session.set 'edit', edit

Template.drinkTmpl.events
  'blur .drink-property-set': (event, tmpl) ->
    self = $(event.target)
    unless self.hasClass 'dropdown'
      readEdit self
  'keydown .drink-property-set': (event) ->
    if event.keyCode is 13
      event.target.blur()
  'click #drink-price': ->
    # Don't buy drinks in editmode...
    if Session.get 'editMode' then return
    $('#tabs-modal').modal
      onApprove: ->
        #Something...
    .modal 'show'

Template.drinkManufacturer.helpers
  hasValidUrl: ->
    SimpleSchema.RegEx.Url.test(@properties.website) or SimpleSchema.RegEx.Url.test('http://' + @properties.website)
  getUrl: ->
    if SimpleSchema.RegEx.Url.test @properties.website
      @properties.website
    else if SimpleSchema.RegEx.Url.test('http://' + @properties.website)
      'http://' + @properties.website
    
Template.drinkOptionsDropdown.rendered = ->
  @$('.ui.dropdown').dropdown()

Template.drinkOptions.events
  'click #drink-edit': (e, tmpl) ->
    Session.set 'editMode', true
    edit = new share.Edit
    drink = Drinks.findOne( currentDrinkId )
    edit.setOriginal drink
    Session.set 'edit', edit
    # Make sure empty properties are truly empty
    # This is to fix strange bugs with :empty -CSS selector not working in some cases
    $('.drink-detail-row').each (index, element) ->
      prop = $(element).find('.drink-property-set').data 'drink-property'
      if _.isEmpty(drink.properties[prop]) then $(element).find('.drink-property-show')[0].innerHTML = ''

  'click #edits-done': ->
    Session.set 'editMode', false
    edit = Session.get 'edit'
    unless Session.get 'addDrink'
      unless _.isEmpty edit.edits
        drink = Drinks.findOne( currentDrinkId )
        redirect = false # If name is changed, then user must be redirected to the new address.
        _.each edit.edits, (oldAndNew, property) ->
          # Clear all attribute fields that will be repopulated by update reactivity
          elements = $('.drink-property-set').filter('[data-drink-property="' + property + '"]')
          if elements.length then elements[0].innerHTML = "&zwnj;"
          # If the name has been edited, then redirect
          if not redirect and property is 'name' then redirect = true
        modifier = _.extend edit.setter(), edit.pusher()
        Drinks.update drink._id, modifier, (err) ->
          if err
            toastr.error err.message
            Session.set 'editMode', true
            _.each edit.edits, (oldAndNew, property) ->
              # Repopulate the fields since the reactivity isn't doing so.
              # There could be a better way of doing this by forcing a 
              # reactive recalculation, maybe figure that out some time.
              elements = $('.drink-property-set').filter('[data-drink-property="' + property + '"]')
              if elements.length then elements[0].innerHTML = oldAndNew.old
          else if redirect
            Router.go 'drink', slug: edit.edits.name.set

    else # Handle new drink add
      Session.set 'addDrink', false
      error = false
      if _.isEmpty edit.edits
        Router.go 'home'
      else
        Drinks.insert edit.get(), (err, id) ->
          if not err
            Meteor.call 'getDrinkName', id, (err, res) ->
              if not err
                Router.go 'drink', slug: res
                toastr.success 'Drink ' + res + ' added.'
              else
                error = err
          else
            error = err
      if error
        toastr.error error.message
        Session.set 'addDrink', true
        Session.set 'editMode', true

  'click #drink-remove': ->
    $('#drink-delete-confirm-modal').modal
      onApprove: ->
        id = currentDrinkId
        Router.go 'home'
        toastr.info 'Drink successfully removed.'
        Drinks.remove id
    .modal 'show'
