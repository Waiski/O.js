Template.searchBar.events
  'keyup #search': (event, tmpl) ->
    content = tmpl.$('#search').text()
    # Clear any generated html elements
    tmpl.$('#search').empty() if not content.length
    Session.set 'search', content
  'keydown #search': (event) ->
    if event.keyCode is 13
      event.target.blur()
  'click .search-container': ->
    $('#search').focus()

Template.drinksList.onRendered ->
  # Maybe someday CSS position: sticky will work in all browsers
  # But for now this requires JS 
  @$('.ui.sticky').sticky
    context: '#drinks-list'

Template.drinksList.helpers
  categories: ->
    Categories.find {}, sort: order: 1

Template.drinkCategory.helpers
  drinks: ->
    search = Diacritics.remove Session.get 'search'
    selector = {nameSearchable: {$regex: search, $options:'i'}, categoryId: @._id}
    if not Session.get 'showAll' then selector.ended = {$ne: true}
    Drinks.find selector, {sort: {name: 1}}
