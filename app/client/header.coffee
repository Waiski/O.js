Template.searchBar.events
  'keyup #search': (event, tmpl) ->
    content = tmpl.$('#search').text()
    # Clear any generated html elements
    tmpl.$('#search').empty() if not content.length
    Session.set 'search', content

Template.searchIcon.events
  'click': ->
    $('#search').focus()

Template.editIcon.events
  'click .fa-pencil': ->
    Session.set 'editMode', true
    edit = new share.Edit
    drink = Drinks.findOne( Session.get 'activeDrinkId' )
    edit.setOriginal drink
    Session.set 'edit', edit
  'click .fa-check': ->
    Session.set 'editMode', false
    edit = Session.get 'edit'
    unless Session.get 'addDrink'
      unless _.isEmpty edit.edits
        drink = Drinks.findOne( Session.get 'activeDrinkId' )
        redirect = false # If name is changed, then user must be redirected to the new address.
        _.each edit.edits, (oldAndNew, property) ->
          # Clear all attribute fields that will be repopulated by update reactivity
          $('.drink-property-set').filter('[data-drink-property="' + property + '"]')[0].innerHTML = ""
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
            if not err then Router.go 'drink', slug: res

Template.backIcon.events
  'click .fa-times': ->
    Session.set 'edit', undefined
    Session.set 'editMode', false
    if Session.get 'addDrink'
      Router.go 'home'

Template.headerTmpl.helpers
  showTemplate: ->
    Template[@.name]
  leftActionTemplate: ->
    Session.get 'leftAction'
  rightActionTemplate: ->
    Session.get 'rightAction'
  headerCenterTemplate: ->
    Session.get 'headerCenter'