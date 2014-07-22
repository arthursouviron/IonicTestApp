# Ionic Starter App

# angular.module is a global place for creating, registering and retrieving Angular modules
# 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
# the 2nd parameter is an array of 'requires'
# 'starter.controllers' is found in controllers.js

# Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
# for form inputs)

# org.apache.cordova.statusbar required
app = angular.module("mobileApp", [
  "ionic",
  "deviseCtrl",
  "applicationCtrl",
  "contactsCtrl",
  "mapsCtrl",
  "settingsCtrl",
  "usersCtrl",
  "conversationsCtrl",
  "loadingServices"
]).run(($ionicPlatform) ->
  $ionicPlatform.ready ->
    cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard
    StatusBar.styleDefault()  if window.StatusBar
    
  return

).factory( 'RequestInterceptor', ($rootScope) ->

  RequestInterceptor = 
    request : (config) ->
      # $ionicLoading.show(
      #   content: '<i class="icon ion-loading-c"></i> Logging in'
      # )
      $rootScope.$broadcast('showLoading');
      if (window.localStorage.getItem('user_email') && window.localStorage.getItem('user_token'))
        config.headers['X-User-Email'] = window.localStorage.getItem('user_email');
        config.headers['X-User-Token'] = window.localStorage.getItem('user_token');
      return config

    response : (response) ->
      $rootScope.$broadcast('hideLoading');

      # if response.statusText == "OK"
        # $ionicLoading.hide()
      return response
  
  return RequestInterceptor

).config( ($stateProvider, $urlRouterProvider, $httpProvider, $compileProvider ) ->
  
  # $compileProvider.imgSrcSanitizationWhitelist(/^\s(https|file|blob|cdvfile):|data:image\//);

  $httpProvider.interceptors.push('RequestInterceptor')


  $stateProvider
  .state("sign_in",
    url: "/sign_in"
    templateUrl: "templates/sign_in.html"
  )
  .state("sign_up",
    url: '/sign_up'
    templateUrl: 'templates/sign_up.html'
    controller: 'DeviseSignUpCtrl'
  )
  .state('app',
    url: "/app",
    abstract: true,
    templateUrl: "templates/menu.html",
    controller: 'AppCtrl'
  )
  .state("app.users",
    url: '/users'
    views:
      'menuContent' :
        templateUrl: 'templates/users.html'
        controller: 'UsersIndexCtrl'
  )
  .state("app.user_details",
    url: '/users/:userId'
    views:
      'menuContent' :
        templateUrl: 'templates/user.html'
        controller: 'UserPageCtrl'
  )
  .state("app.conversations",
    url: '/conversations'
    views:
      'menuContent' :
        templateUrl: 'templates/conversation.html'
        controller: 'ConversationIndexCtrl'
  )
  .state("app.conversation_details",
    url: '/conversations/:conversationId'
    views:
      'menuContent' :
        templateUrl: 'templates/conversation.html'
        controller: 'ConversationPageCtrl'
  )
  .state("app.contacts",
    url: '/contacts'
    views:
      'menuContent' :
        templateUrl: 'templates/contacts.html'
        controller: 'ContactIndexCtrl'
  )
  .state("app.contact_new"
    url: '/contacts/new'
    views:
      'menuContent' :
        templateUrl: "templates/new_contact.html"
        controller: 'ContactNewCtrl'
  )
  .state("app.contact_details",
    url: '/contacts/:contactId'
    views:
      'menuContent' :
        templateUrl: "templates/contact.html"
        controller: 'ContactPageCtrl'
  )

  .state("app.maps",
    url: '/maps'
    views: 
      'menuContent' :
        templateUrl: 'templates/maps.html'
  )
  .state("app.settings",
    url: '/settings'
    views:
      'menuContent' :
        templateUrl: 'templates/settings.html'
        controller: 'SettingCtrl'
  )
  .state("app.sign_out",
    url: '/sign_out'
    views:
      'menuContent' :
        template: '<ion-view></ion-view>'
        controller: 'DeviseSignOutCtrl'
  )
  # ).state("app.search",
  #   url: "/search"
  #   views:
  #     menuContent:
  #       templateUrl: "templates/search.html"
  # ).state("app.browse",
  #   url: "/browse"
  #   views:
  #     menuContent:
  #       templateUrl: "templates/browse.html"
  # ).state("app.playlists",
  #   url: "/playlists"
  #   views:
  #     menuContent:
  #       templateUrl: "templates/playlists.html"
  #       controller: "PlaylistsCtrl"
  # ).state "app.single",
  #   url: "/playlists/:playlistId"
  #   views:
  #     menuContent:
  #       templateUrl: "templates/playlist.html"
  #       controller: "PlaylistCtrl"

  
  # if none of the above states are matched, use this as the fallback
  $urlRouterProvider.otherwise "/sign_in"
# )
)
  

