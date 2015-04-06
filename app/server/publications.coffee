Meteor.publish "drinks", ->
  Drinks.find()

Meteor.publish "drink", (name) ->
  Drinks.find name: name

Meteor.publish "categories", ->
  Categories.find()