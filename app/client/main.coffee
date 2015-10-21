# Global client-side scripts go here

Meteor.Spinner.options = 
    radius: 70,
    speed: 0.5,
    width: 20,
    length: 50

Template.registerHelper 'editmode', ->
    Session.get 'editMode'

Meteor.startup ->
   $(window).resize ->
     Session.set 'viewportWidth', $(window).width()