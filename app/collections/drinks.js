Drinks = new Mongo.Collection('drinks', {
  transform: function(doc) {
    return new Drink(doc);
  }
});

Drink = function (doc) {
  _.extend(this, doc);
};

Drink.prototype = {
  constructor: Drink,

  // The normally editable top-level properties
  topLevelProps: ['name', 'price', 'categoryId'],

  buy: function() {
    // Logic to buy a drink...
  }
};

Drinks.attachSchema(new SimpleSchema({
  name: {
    type: String
  },
  price: {
    type: Number
  },
  categoryId: {
    type: String,
    regEx: SimpleSchema.RegEx.Id
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
    }
  },
  // Perhaps, at some point, a more throrough schema for properties could be done
  properties: {
    type: Object,
    defaultValue: {},
    blackbox: true
  },
  editHistory: {
    type: [Object],
    optional: true,
  },
  "editHistory.$": {
    type: __coffeescriptShare.EditSchema
  }
}));
