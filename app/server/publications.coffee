isAdmin = (id) ->
  Roles.userIsInRole id, 'admin'

Meteor.publish "drinks", ->
  unless @userId is null
    Drinks.find()

Meteor.publish "drink", (name) ->
  unless @userId is null
    Drinks.find name: name

Meteor.publish "categories", ->
  unless @userId is null
    Categories.find()

Meteor.publish "users", ->
  unless @userId is null
    if isAdmin @userId
      Meteor.users.find {}, fields:
        services: 0
    else
      Meteor.users.find {}, fields:
        services: 0
        emails: 0
        createdAt: 0


Meteor.publish "roles", ->
  if @userId isnt null and isAdmin @userId
    Meteor.roles.find()

Meteor.publish "transactions", ->
  unless @userId is null
    if isAdmin @userId
      Transactions.find()
    else
      Transactions.find userId: @userId

Meteor.publish "myTransactions", ->
  unless @userId is null
    Transactions.find userId: @userId 