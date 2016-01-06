Template.usersOptionsDropdown.events
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
    search = Session.get 'search'
    searchObj =
      $regex: search
      $options:'i'
    Meteor.users.find(
      {$or: [{username: searchObj}, {'emails.0.address': searchObj}]},
      sort: {username: 1})
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
  'click .user-row': (e, thisTmpl) ->
    id = this._id
    Session.set 'userIdBeingEdited', id
    $('#edit-user-modal').modal
      transition: 'fade'
      onShow: ->
        rolesEl = $(this).find('select[name="roles"]')
        rolesEl.select2().select2 'val', Roles.getRolesForUser id
      onVisible: ->
        $(this).find('#delete-user').click ->
          $('#delete-user-modal').modal
            onApprove: ->
              Meteor.users.remove id, (error) ->
                if error
                  toastr.error error.message
                else
                  toastr.success 'User successfully removed'
          .modal 'show'
      onApprove: ->
        form = $('#edit-user-form')
        data =
          'username': form.find('input[name="username"]').val()
          'email': form.find('input[name="email"]').val()
        Meteor.users.update id, $set: data, (error) ->
          if error
            toastr.error error.message
          else
            toastr.success 'User updated!'
        roles = $(this).find('select[name="roles"]').select2 'val'
        if not roles then roles = []
        Roles.setUserRoles id, roles
    .modal 'show'

Template.editUserModal.helpers
  user: ->
    user = Meteor.users.findOne(Session.get 'userIdBeingEdited')
    if user
      user
    # Return a dummy user so that all elements are still created
    else
      _id: '000'
      username: 'JaloJ'
      emails: [{ address: 'jjalo@oty.fi' }]
  roles: ->
    Meteor.roles.find()
