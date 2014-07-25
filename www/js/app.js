(function() {
  var app;

  app = angular.module("mobileApp", ["ionic", "deviseCtrl", "applicationCtrl", "contactsCtrl", "mapsCtrl", "settingsCtrl", "usersCtrl", "conversationsCtrl", "loadingServices"]).run(function($ionicPlatform) {
    $ionicPlatform.ready(function() {
      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        return StatusBar.styleDefault();
      }
    });
  }).factory('RequestInterceptor', function($rootScope) {
    var RequestInterceptor;
    RequestInterceptor = {
      request: function(config) {
        $rootScope.$broadcast('showLoading');
        if (window.localStorage.getItem('user_email') && window.localStorage.getItem('user_token')) {
          config.headers['X-User-Email'] = window.localStorage.getItem('user_email');
          config.headers['X-User-Token'] = window.localStorage.getItem('user_token');
        }
        return config;
      },
      response: function(response) {
        $rootScope.$broadcast('hideLoading');
        return response;
      }
    };
    return RequestInterceptor;
  }).config(function($stateProvider, $urlRouterProvider, $httpProvider, $compileProvider) {
    $httpProvider.interceptors.push('RequestInterceptor');
    $stateProvider.state("sign_in", {
      url: "/sign_in",
      templateUrl: "templates/sign_in.html"
    }).state("sign_up", {
      url: '/sign_up',
      templateUrl: 'templates/sign_up.html',
      controller: 'DeviseSignUpCtrl'
    }).state('app', {
      url: "/app",
      abstract: true,
      templateUrl: "templates/menu.html",
      controller: 'AppCtrl'
    }).state("app.users", {
      url: '/users',
      views: {
        'menuContent': {
          templateUrl: 'templates/users.html',
          controller: 'UsersIndexCtrl'
        }
      }
    }).state("app.user_details", {
      url: '/users/:userId',
      views: {
        'menuContent': {
          templateUrl: 'templates/user.html',
          controller: 'UserPageCtrl'
        }
      }
    }).state("app.conversations", {
      url: '/conversations',
      views: {
        'menuContent': {
          templateUrl: 'templates/conversation.html',
          controller: 'ConversationIndexCtrl'
        }
      }
    }).state("app.conversation_details", {
      url: '/conversations/:conversationId?msg',
      views: {
        'menuContent': {
          templateUrl: 'templates/conversation.html',
          controller: 'ConversationPageCtrl'
        }
      }
    }).state("app.contacts", {
      url: '/contacts',
      views: {
        'menuContent': {
          templateUrl: 'templates/contacts.html',
          controller: 'ContactIndexCtrl'
        }
      }
    }).state("app.contact_new", {
      url: '/contacts/new',
      views: {
        'menuContent': {
          templateUrl: "templates/new_contact.html",
          controller: 'ContactNewCtrl'
        }
      }
    }).state("app.contact_details", {
      url: '/contacts/:contactId',
      views: {
        'menuContent': {
          templateUrl: "templates/contact.html",
          controller: 'ContactPageCtrl'
        }
      }
    }).state("app.maps", {
      url: '/maps',
      views: {
        'menuContent': {
          templateUrl: 'templates/maps.html'
        }
      }
    }).state("app.settings", {
      url: '/settings',
      views: {
        'menuContent': {
          templateUrl: 'templates/settings.html',
          controller: 'SettingCtrl'
        }
      }
    }).state("app.sign_out", {
      url: '/sign_out',
      views: {
        'menuContent': {
          template: '<ion-view></ion-view>',
          controller: 'DeviseSignOutCtrl'
        }
      }
    });
    return $urlRouterProvider.otherwise("/sign_in");
  });

}).call(this);
