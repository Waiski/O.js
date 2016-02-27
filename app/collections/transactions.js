Transactions = new Mongo.Collection('transactions', {
  transform: function(doc) {
    return new Transaction(doc);
  }
});

Transaction = function (doc) {
  _.extend(this, doc);
};

Transaction.prototype = {
  constructor: Transaction
};

Transactions.after.insert(function(uid, doc) {
  // Note: uid is the maker of the transaction, not
  // necessarily the one whose tab is being used

  // Note that these are only done on the server, so
  // that the value wouldn't be incremented twice.
  if (Meteor.isServer) {
    // $inc -operator increments the value
    Meteor.users.update(doc.userId, {$inc: {
      tabValue: doc.amount
    }, $set: {
      lastActive: new Date
    }});
  }
});

// I'm not sure if any updates to the amount should be done,
// but better be prepared. The rules only allow transactions
// modification for admins.
Transactions.after.update(function(uid, doc) {
  var difference = this.previous.amount - doc.amount
  // $inc -operator increments the value
  if (Meteor.isServer) {
    Meteor.users.update(doc.userId, {$inc: {
      tabValue: difference
    }});
  }
});
Transactions.after.remove(function(uid, doc) {
  if (Meteor.isServer) {
    Meteor.users.update(doc.userId, {$inc: {
      tabValue: -doc.amount
    }});
  }
});

var TransactionSchema = new SimpleSchema({
  userId: {
    type: String,
    regEx: SimpleSchema.RegEx.Id
  },
  // The logged in user who performs the action
  doneBy: {
    type: String,
    regEx: SimpleSchema.RegEx.Id,
    autoValue: function() {
      // rules.js takes care that only logged-in users do this,
      // so there's no need to check the validity of this.userId
      if (this.isInsert) {
        return this.userId;
      } else if (this.isUpsert) {
        return {$setOnInsert: this.userId};
      } else {
        this.unset();  // Prevent user from supplying their own value
      }
    }
  },
  amount: {
    type: Number,
    decimal: true
  },
  "drink.name": {
    type: String,
    optional: true
  },
  "drink.id": {
    type: String,
    optional: true,
    regEx: SimpleSchema.RegEx.Id
  },
  time: {
    type: Date,
    autoValue: function() {
      if (this.isInsert) {
        return new Date();
      } else if (this.isUpsert) {
        return {$setOnInsert: new Date()};
      } else {
        this.unset();  // Prevent user from supplying their own value
      }
    }
  },
  // For special transactions
  description: {
    type: String,
    optional: true
  }
});

Transactions.attachSchema(TransactionSchema);
