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

Template.headerTmpl.helpers
  showTemplate: ->
    Template[@.name]
  headerCenterTemplate: ->
    Session.get 'headerCenter'