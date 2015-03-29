Template.drinksList.helpers({
  'drinks': function() {
    return Drinks.find();
  }
});