Meteor.startup ->
  # code to run on server at startup
  if Meteor.users.find().count() is 0
    # Add a default user
    adminId = Accounts.createUser
      username: 'admin'
      password: 'adminsalasanaonihansikavahva'
      email: 'valtter@vihervuori.fi'
      profile:
        name: 'Administrator'

    Roles.addUsersToRoles adminId, 'admin'

  unless Meteor.roles.findOne( name: 'admin' )
    Roles.createRole 'admin'

  unless Meteor.roles.findOne( name: 'user' )
    Roles.createRole 'user'

  process.env.MAIL_URL = 'smtp://postmaster%40sandbox186cd8745abd449e91d8d4786b7985fd.mailgun.org:8afe68722894c9042d5a793b0a94689e@smtp.mailgun.org:587'
  

Meteor.methods
  # Get the name of a drink without the need to subscribe to it
  # Remember to include auth check when accounts are implemented
  getDrinkName: (id) ->
    unless @userId is null
      drink = Drinks.findOne(id)
      if drink then drink.name else undefined
  inviteUser: (data) ->
    if Roles.userIsInRole @userId, 'admin'
      data.password = Random.id(10)
      data.profile = {}
      id = Accounts.createUser data
      Roles.addUsersToRoles id, 'user'
      Email.send
        'from': 'OJS-noreply <noreply@otnas.fi>'
        'to': data.email
        'subject': 'Welcome to o.js'
        'text': 'Your account at ' + Router.url('home') + ' has been created. ' + 
                'Please login using your email address: ' + data.email + ' and ' +
                'password: ' + data.password + ' Please change your password as ' +
                'soon as possible.'

  isDevelopment: ->
    process.env.NODE_ENV is 'development'
