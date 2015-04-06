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
    // If returning from editing, ensure that aditmode is not preserved
    Session.set('editMode', false);
    Session.set('search', '');
    this.next();
  },
  waitOn: function() {
    return [
      Meteor.subscribe("drinks"),
      Meteor.subscribe("categories")
    ]
  }
});

Router.route('/:slug', function() {
  this.render('headerTmpl', {to: 'header'});
  this.render('drink', {
    data: Drinks.findOne({name: this.params.slug})
  });
}, {
  name: 'drink',
  onBeforeAction: function() {
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'editIcon');
    Session.set('headerCenter', 'empty');
    // Don't reset editmode on reactive reruns
    Session.setDefault('editMode', false);
    Session.set('mainContentTransition', 'slideWindowLeft');
    this.next();
  },
  waitOn: function() {
    return Meteor.subscribe("drink", this.params.slug)
  }
});