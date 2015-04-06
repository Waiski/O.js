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
  'click .fa-check': ->
    Session.set 'editMode', false

Template.headerTmpl.helpers
  showTemplate: ->
    Template[@.name]
  leftActionTemplate: ->
    Session.get 'leftAction'
  rightActionTemplate: ->
    Session.get 'rightAction'
  headerCenterTemplate: ->
    Session.get 'headerCenter'