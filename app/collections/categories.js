Categories = new Mongo.Collection('categories', {
  transform: function(doc) {
    return new Category(doc);
  }
});

Category = function (doc) {
  _.extend(this, doc);
};

Category.prototype = {
  constructor: Category
};

Categories.attachSchema(new SimpleSchema({
	name: {
		type: String
	},
	createdAt: {
		type: Date,
    autoValue: function() {
      if (this.isInsert) {
        return new Date();
      } else if (this.isUpsert) {
        return {$setOnInsert: new Date()};
      } else {
        this.unset();  // Prevent user from supplying their own value
      }
    },
    optional: true
	},
	createdBy: {
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
    },
    optional: true
	}
}));
