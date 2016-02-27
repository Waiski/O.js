Template.searchBar.events
  'keyup #search': (event, tmpl) ->
    content = tmpl.$('#search').text()
    # Clear any generated html elements
    tmpl.$('#search').empty() if not content.length
    Session.set 'search', content
  'keydown #search': (event) ->
    if event.keyCode is 13
      event.target.blur()

Template.searchIcon.events
  'click': ->
    $('#search').focus()

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