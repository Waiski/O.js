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
    unless _.isEmpty edit.edits
      drink = Drinks.findOne( Session.get 'activeDrinkId' )
      _.each edit.edits, (oldAndNew, property) ->
        # Clear all attribute fields that will be repopulated by update reactivity
        $('.drink-property').filter('[data-drink-property="' + property + '"]')[0].innerHTML = ""
      Drinks.update drink._id, edit.setter()

Template.headerTmpl.helpers
  showTemplate: ->
    Template[@.name]
  leftActionTemplate: ->
    Session.get 'leftAction'
  rightActionTemplate: ->
    Session.get 'rightAction'
  headerCenterTemplate: ->
    Session.get 'headerCenter'