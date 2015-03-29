Router.configure({
  layoutTemplate: 'layout'
});

Router.route('/', function() {
    this.render('headerTmpl', {to: 'header'});
    this.render('drinksList');
});