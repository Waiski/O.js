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

// Remove cyrillic characters for searchable string
// From: http://stackoverflow.com/questions/11404047/transliterating-cyrillic-to-latin-with-javascript-function
var transliterate = function (word){
  var charMap = { "Ё":"YO","Й":"I","Ц":"TS","У":"U",
  "К":"K","Е":"E","Н":"N","Г":"G","Ш":"SH","Щ":"SCH",
  "З":"Z","Х":"H","Ъ":"'","ё":"yo","й":"i","ц":"ts",
  "у":"u","к":"k","е":"e","н":"n","г":"g","ш":"sh",
  "щ":"sch","з":"z","х":"h","ъ":"'","Ф":"F","Ы":"I",
  "В":"V","А":"a","П":"P","Р":"R","О":"O","Л":"L",
  "Д":"D","Ж":"ZH","Э":"E","ф":"f","ы":"i","в":"v",
  "а":"a","п":"p","р":"r","о":"o","л":"l","д":"d",
  "ж":"zh","э":"e","Я":"Ya","Ч":"CH","С":"S","М":"M",
  "И":"I","Т":"T","Ь":"'","Б":"B","Ю":"YU","я":"ya",
  "ч":"ch","с":"s","м":"m","и":"i","т":"t","ь":"'",
  "б":"b","ю":"yu" };
  return word.split('').map(function (char) { 
    return charMap[char] || char; 
  }).join("");
}

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
        return transliterate(Diacritics.remove(name.value));
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
