var isAdmin = function(user) {
    if (!user)
        user = Meteor.user();
    return Roles.userIsInRole(user, "admin");
};

Meteor.users.allow({
    insert: function (userId, doc) {
        return false;
    },
    update: function (userId, doc, fields, modifier) {
        if (isAdmin(userId)) {
            return true;
        } else if (userId === doc._id) {
            if (_.difference(fields, ['username', 'email']).length === 0) {
                return true;
            }
        }
        return false;
    },
    remove: function (userId, doc) {
        return isAdmin(userId);
    }
});