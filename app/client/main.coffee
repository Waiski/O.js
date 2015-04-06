Template.registerHelper 'editmode', ->
    Session.get 'editMode'

Template.layout.helpers
  getMaincontentTransition: ->
    Session.get 'mainContentTransition'

Meteor.startup ->
   $(window).resize ->
     Session.set 'viewportWidth', $(window).width()