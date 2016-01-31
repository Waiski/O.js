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
    type: Number
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
