Router.configure({
  layoutTemplate: 'layout'
});

Router.route('/', function() {
  this.render('headerTmpl', {to: 'header'});
  this.render('drinksList');
}, {
  name: 'home',
  onBeforeAction: function() {
    Session.set('leftAction', 'searchIcon');
    Session.set('rightAction', 'addIcon');
    Session.set('headerCenter', 'searchBar');
    Session.set('mainContentTransition', 'slideWindowRight');
    this.next();
  }
});

Router.route('/:slug', function() {
  this.render('headerTmpl', {to: 'header'});
  this.render('drink', {
    data: function() {
      return Drinks.findOne({name: this.params.slug});
    }
  });
}, {
  name: 'drink',
  onBeforeAction: function() {
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'editIcon');
    Session.set('headerCenter', 'empty');
    Session.set('mainContentTransition', 'slideWindowLeft');
    this.next();
  }
});