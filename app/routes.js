Router.configure({
  layoutTemplate: 'layout'
});

Router.route('/', function() {
  Session.set('leftAction', 'searchIcon');
  Session.set('rightAction', 'empty');
  Session.set('headerCenter', 'searchBar');
  this.render('headerTmpl', {to: 'header'});
  this.render('drinksList');
});