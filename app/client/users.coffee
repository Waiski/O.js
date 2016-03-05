Template.mainMenu.events
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
  getUserId: ->
    userid: @_id

Template.usersList.created = ->
  Session.set 'userIdBeingEdited', undefined

Template.usersList.events
  'click .user-row': (e, thisTmpl) ->
    # Let links do their own thing
    target = $(e.target)
    # If clicked element is link, or within a link
    if target.is('a') or target.parents('a').length > 0
      return
    # Otherwise open user edit modal
    id = this._id
    Session.set 'userIdBeingEdited', id
    $('#edit-user-modal').modal
      transition: 'fade'
      onShow: ->
        rolesEl = $(this).find('select[name="roles"]')
        rolesEl.val Roles.getRolesForUser id
        rolesEl.select2()
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
        roles = $(this).find('select[name="roles"]').val()
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
