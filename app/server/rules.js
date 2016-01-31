var isAdmin = function(user) {
  if (!user)
    user = Meteor.user();
  return Roles.userIsInRole(user, "admin");
};

var isUser = function(userId) {
  return _.isString(userId);
}

var no = function() {
  return false;
}

Meteor.users.allow({
  insert: function (userId, doc) {
    return false;
  },
  update: function (userId, doc, fields, modifier) {
    if (isAdmin(userId)) {
      return true;
    } else if (userId === doc._id) {
      // Allow non-admins to only edit some fo their own info
      if (_.difference(fields, ['username', 'email']).length === 0) {
        return true;
      }
    }
    return false;
  },
  remove: isAdmin
});

Categories.allow({
  insert: isUser,
  update: isUser,
  remove: isAdmin
});

Drinks.allow({
  insert: isUser,
  update: isUser,
  remove: isUser
});

// Once the schema is set, this should be perhamps made more 
// elaborate so that only standard transactions are allowed
// for normal users.
Transactions.allow({
 insert: isUser,
 update: isUser,
 remove: isAdmin
});
