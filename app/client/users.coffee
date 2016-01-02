Template.mainOptionsDropdown.events
  'click #invite-user': ->
    $('#invite-user-modal').modal
      onApprove: ->
        form = $('#invite-user-form')
        data =
          'username': form.find('input[name="username"]').val()
          'email': form.find('input[name="email"]').val()
        Meteor.call 'inviteUser', data, (error, value) ->
          if error
            toastr.error error.message
          else
            toastr.success 'User suffessfully added'
    .modal 'show'

Template.usersList.helpers
  users: ->
    Meteor.users.find()
  color: (role) ->
    if role is 'admin'
      'red'
    else if role is 'user'
      'green'
    else
      'blue' 

