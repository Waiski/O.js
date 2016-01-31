# Global client-side scripts go here

Meteor.Spinner.options = 
  radius: 70,
  speed: 0.5,
  width: 30,
  length: 50

Template.registerHelper 'editmode', ->
  Session.get 'editMode'

Template.registerHelper 'getValue', (value) ->
  # Circumvent the issue that the HTML node might
  # not be created if the value is not set. 
  if value
    value
  else if @value
    @value
  else
    ''

Meteor.startup ->
  Deps.autorun ->
  title = Session.get 'documentTitle'
  title = if title then title else 'O.js'
  document.title = title
###
   $(window).resize ->
   Session.set 'viewportWidth', $(window).width()
###

Template.mainOptionsDropdown.rendered = ->
  @$('.ui.dropdown').dropdown()

Template.usersOptionsDropdown.rendered = ->
  @$('.ui.dropdown').dropdown()

Template.logoutLink.events
  'click #logout': ->
    AccountsTemplates.logout()
