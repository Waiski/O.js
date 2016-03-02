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

var DrinkSchema = new SimpleSchema({
  name: {
    type: String,
    unique: true,
    index: true,
    custom: function() {
      // Ensure that the drink name does not conflict with any route
      // and that there are no slashes in the name.
      if (_.contains(SpecialRoutes, this.value.toLowerCase()))
        return 'reservedName';
      if (this.value.indexOf('/') > -1)
        return 'noSlashes';
      return true;
    }
  },
  // Since drink names often contain accents,
  // and that makes searching difficult, make
  // a version of the name that can be searched
  // diacritic-insensitively
  nameSearchable: {
    type: String,
    index: true,
    optional: true,
    autoValue: function() {
      var name = this.field('name');
      if (name.isSet)
        return Diacritics.remove(name.value);
      else
        this.unset();
    }
  },
  price: {
    type: Number,
    decimal: true
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
  ended: {
    type: Boolean,
    optional: true
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
});

DrinkSchema.messages({
  'reservedName': 'Sorry, you can\'t use that as drink name!',
  'noSlashes': 'Sorry, you can\'t use slashes in the drink name!'
});

Drinks.attachSchema(DrinkSchema);
