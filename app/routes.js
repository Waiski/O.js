Router.configure({
  layoutTemplate: 'layout'
});

Router.route('/', {
  name: 'home',
  onBeforeAction: function() {
    Session.set('leftAction', 'searchIcon');
    Session.set('rightAction', 'addIcon');
    Session.set('headerCenter', 'searchBar');
    // If returning from editing, ensure that editmode is not preserved
    Session.set('editMode', false);
    Session.set('search', '');
    this.next();
  },
  action: function() {
    this.subscribe("drinks").wait();
    this.subscribe("categories").wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready()) {
      this.render('drinksList');
    } else
      this.render('loading');
  }
});

Router.route('/:slug', {
  name: 'drink',
  onBeforeAction: function() {
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'editIcon');
    Session.set('headerCenter', 'empty');
    // Don't reset editmode on reactive reruns
    Session.setDefault('editMode', false);
    this.next();
  },
  action: function() {
    this.subscribe("drink", this.params.slug).wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready()) {
      var drink = Drinks.findOne({name: this.params.slug});
      Session.set('activeDrinkId', drink._id);
      this.render('drink', {
        data: drink
      });
    } else
      this.render('loading');
  }
});

Router.route('/add', {
  name: 'addDrink',
  onBeforeAction: function() {
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'editIcon');
    Session.set('headerCenter', 'empty');
    // Don't reset editmode on reactive reruns
    Session.setDefault('editMode', false);
    this.next();
  },
  action: function() {
    this.subscribe("drink", this.params.slug).wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready()) {
      this.render('drink', {
        data: { addition: true }
      });
    } else
      this.render('loading');
  }
});