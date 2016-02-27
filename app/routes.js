Router.configure({
  layoutTemplate: 'layout'
});

// Accounts configuration
AccountsTemplates.configure({
    // Behavior
    enablePasswordChange: true,
    forbidClientAccountCreation: true,
    overrideLoginErrors: true,

    // Appearance
    showForgotPasswordLink: true,
    showResendVerificationEmailLink: false,

    // Client-side Validation
    showValidating: true,

    // Privacy Policy and Terms of Use
    // privacyUrl: 'privacy',

    // Redirects
    homeRoutePath: '/',
    redirectTimeout: 2000,
});

// Accounts routes
AccountsTemplates.configureRoute('signIn', {
    name: 'signin',
    path: '/login'
});

// TODO: set document titles for accounts-related stuff

AccountsTemplates.configureRoute('changePwd');
AccountsTemplates.configureRoute('forgotPwd');
AccountsTemplates.configureRoute('resetPwd');

// Protect non-account-related pages.
Router.plugin('ensureSignedIn', {
  except: _.pluck(AccountsTemplates.routes, 'name').concat([
    // No public routes at this point
  ])
});

var resetSession = function() {
  // If returning from editing, ensure that editmode is not preserved
  Session.set('editMode', false);
  Session.set('addDrink', false);
  Session.set('search', '');
  Session.set('edit', undefined);
};

Router.route('/', {
  name: 'home',
  onBeforeAction: function() {
    Session.set('documentTitle', 'O.js - Drinks');
    Session.set('leftAction', 'empty');
    Session.set('rightAction', 'mainOptionsDropdown');
    Session.set('headerCenter', 'searchBar');
    resetSession();
    this.next();
  },
  action: function() {
    this.subscribe('drinks').wait();
    this.subscribe('categories').wait();
    this.subscribe('myTransactions').wait();
    this.subscribe('users').wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready()) {
      this.render('drinksList');
    } else
      this.render('loading');
  }
});

// A global array of special routes, used so that a drink name cannot collide with any of these
// Remember to specify all these in lowercase, as the comparison is made with String.toLowerCase()
SpecialRoutes = ['add', 'users', 'login', 'change-password', 'forgot-password', 'reset-password', 'sign-up', 'verify-email', 'send-again'];

Router.route('/add', {
  name: 'add',
  onBeforeAction: function() {
    Session.set('documentTitle', 'O.js - Add drink');
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'drinkOptions');
    Session.set('headerCenter', 'empty');
    Session.set('addDrink', true);
    Session.set('editMode', true);
    Session.set('edit', new __coffeescriptShare.Edit());
    this.next();
  },
  action: function() {
    this.subscribe("categories").wait();
    // Subscribe to drinks so that name uniqueness can be cheched in front-end
    this.subscribe('drinks').wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready()) {
      this.render('drinkTmpl', {
        data: { addition: true }
      });
    } else
      this.render('loading');
  }
});

Router.route('/users', {
  name: 'users',
  onBeforeAction: function() {
    Session.set('documentTitle', 'O.js - Manage users');
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'usersOptionsDropdown');
    Session.set('headerCenter', 'searchBar');
    resetSession();
    this.next();
  },
  action: function() {
    this.subscribe('users').wait();
    this.subscribe('roles').wait();
    this.subscribe('transactions').wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready()) {
      this.render('usersList');
    } else
      this.render('loading');
  }
});


// THIS MUST BE DEFINED LAST SO THAT ALL OTHER ROUTES TAKE PRECEDENCE
Router.route('/:slug', {
  name: 'drink',
  onBeforeAction: function() {
    Session.set('documentTitle', 'O.js - ' + this.params.slug);
    Session.set('leftAction', 'backIcon');
    Session.set('rightAction', 'drinkOptions');
    Session.set('headerCenter', 'empty');
    Session.set('addDrink', false);
    Session.set('activeDrinkId', undefined);
    // Don't reset editmode on reactive reruns
    Session.setDefault('editMode', false);
    this.next();
  },
  action: function() {
    if (!this.params.slug)
      this.redirect('home');
    this.subscribe('drinks').wait();
    this.subscribe('categories').wait();
    this.subscribe('myTransactions').wait();
    this.subscribe('users').wait();
    this.render('headerTmpl', {to: 'header'});
    if (this.ready())
      this.render('drinkTmpl', {
        data: { drinkName: this.params.slug }
      });
    else
      this.render('loading');
  }
});
