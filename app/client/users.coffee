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
            # Empty form
            form.find('input[name="username"]').val('')
            form.find('input[name="email"]').val('')
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

Template.usersList.created = ->
  Session.set 'userIdBeingEdited', undefined

Template.usersList.events
  'click .user-row': ->
    id = this._id
    Session.set 'userIdBeingEdited', id
    $('#edit-user-modal').modal
      onShow: ->
        rolesEl = $('#edit-user-form').find('select[name="roles"]')
        rolesEl.select2()
        rolesEl.select2 'val', Roles.getRolesForUser id
      onApprove: ->
        form = $('#edit-user-form')
        data =
          'username': form.find('input[name="username"]').val()
          'email': form.find('input[name="email"]').val()
        Meteor.users.update( id, $set: data, callback )
    .modal 'show'

Template.editUserModal.helpers
  user: ->
    Meteor.users.findOne(Session.get 'userIdBeingEdited')
  roles: ->
    Meteor.roles.find()
