Template.drinksList.onRendered ->
  # Maybe someday CSS position: sticky will work in all browsers
  # But for now this requires JS 
  @$('.ui.sticky').sticky
    context: '#drinks-list'

Template.drinksList.helpers
  categories: ->
    Categories.find()

Template.drinkCategory.helpers
  drinks: ->
    search = Session.get 'search'
    Drinks.find {nameSearchable: {$regex: search, $options:'i'}, categoryId: @._id}, {sort: {name: 1}}

Template.userTabsModal.helpers
  users: ->
    Meteor.users.find()

Template.userTabsModal.events
  'click .user-tab-card': ->
    console.log @
