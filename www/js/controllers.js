(function() {
  var appCtrl;

  appCtrl = angular.module('applicationCtrl', ['ionic']);

  appCtrl.controller('AppCtrl', function($rootScope, loadingService) {
    $rootScope.$on('showLoading', function() {
      return loadingService.show();
    });
    return $rootScope.$on('hideLoading', function() {
      return loadingService.hide();
    });
  });

}).call(this);

(function() {
  var contactsCtrl;

  contactsCtrl = angular.module('contactsCtrl', ['contactsServices']);

  contactsCtrl.controller('ContactIndexCtrl', function($scope, contactService) {
    $scope.title = "Contacts";
    contactService.fetchContacts({
      success: function(data) {
        $scope.contacts = {};
        return $scope.contacts = data;
      }
    });
    return $scope.deleteContact = function(item) {
      return contactService.deleteContact({
        contactId: item.id,
        success: function() {
          return $scope.contacts.splice(item, 1);
        },
        error: function() {
          return alert('error');
        }
      });
    };
  }).controller('ContactPageCtrl', function($scope, $stateParams, contactService) {
    $scope.contact = {};
    $scope.contact.first_name = "";
    $scope.contact.last_name = "";
    $scope.contact.email = "";
    $scope.title = "Single Contact";
    return contactService.fetchContact({
      contactId: $stateParams.contactId,
      success: function(data) {
        return $scope.contact = data;
      }
    });
  }).controller('ContactNewCtrl', function($scope, contactService, $location) {
    $scope.title = "New Contact";
    $scope.contactForm = {};
    $scope.contactForm.first_name = "";
    $scope.contactForm.last_name = "";
    $scope.contactForm.email = "";
    return $scope.createContact = function() {
      return contactService.saveContact({
        data: {
          first_name: $scope.contactForm.first_name,
          last_name: $scope.contactForm.last_name,
          email: $scope.contactForm.email
        },
        success: function() {
          return $location.path('/app/contacts');
        }
      });
    };
  });

}).call(this);

(function() {
  var conversationsCtrl;

  conversationsCtrl = angular.module('conversationsCtrl', ['conversationsServices', 'pushNotificationsServices', 'applicationServices']);

  conversationsCtrl.controller('conversationsIndexCtrl', function($scope, conversationsService) {
    $scope.title = "All conversations";
    $scope.conversations = {};
    return conversationsService.fetchConversations({
      success: function(data) {
        return $scope.conversations = data;
      }
    });
  }).controller('ConversationPageCtrl', function($scope, $rootScope, $stateParams, conversationsService, $ionicScrollDelegate, pushNotificationsService, applicationService) {
    var createConversation;
    $scope.conversation = {};
    $scope.msgInput = "";
    $scope.user = applicationService.getUser();
    createConversation = function() {
      return conversationsService.createConversation({
        conversationId: $stateParams.conversationId,
        success: function(data) {
          $scope.conversation = data;
          return $scope.conversation.messages = [];
        },
        error: function() {
          return alert('error create convers');
        }
      });
    };
    $rootScope.$on('msgReceivedlol', function(scope, obj) {
      var message;
      message = {
        content: obj.msg,
        sender_id: obj.sender_id,
        destination_id: $scope.user.id
      };
      if (!$scope.conversation.messages) {
        $scope.conversation.messages = [];
      }
      $scope.conversation.messages.push(angular.extend({}, message));
      return $ionicScrollDelegate.scrollBottom(true);
    });
    conversationsService.fetchConversation({
      conversationId: $stateParams.conversationId,
      success: function(data) {
        console.log(data);
        if (!data.conversation) {
          return createConversation();
        } else {
          $scope.conversation.messages = data.messages;
          $ionicScrollDelegate.scrollBottom(true);
          if ($stateParams.msg) {
            return $rootScope.$broadcast('msgReceivedlol', {
              msg: $stateParams.msg,
              sender_id: $stateParams.conversationId
            });
          }
        }
      },
      error: function() {
        return createConversation();
      }
    });
    return $scope.sendMessage = function() {
      return conversationsService.sendMessage({
        msg: $scope.msgInput,
        conversationId: $stateParams.conversationId,
        success: function() {
          var message;
          message = {
            content: $scope.msgInput,
            sender_id: $scope.user.id,
            destination_id: $stateParams.conversationId
          };
          $scope.conversation.messages.push(angular.extend({}, message));
          console.log(message);
          $scope.msgInput = "";
          return $ionicScrollDelegate.scrollBottom(true);
        },
        error: function() {
          return alert('ERROR CREATE MSG');
        }
      });
    };
  });

}).call(this);

(function() {
  var deviseCtrl;

  deviseCtrl = angular.module('deviseCtrl', ['deviseServices', 'loadingServices', 'pushNotificationsServices']);

  deviseCtrl.controller('DeviseLoginCtrl', function($scope, $location, deviseService, loadingService, $state, pushNotificationsService) {
    $scope.title = 'TITELU';
    $scope.loginForm = {};
    deviseService.loadSession({
      success: function() {
        pushNotificationsService.initPush();
        return $state.go('app.contacts', {}, {
          location: 'replace'
        });
      }
    });
    return $scope.login = function() {
      loadingService.show({
        content: 'Logging in'
      });
      return deviseService.login({
        email: $scope.loginForm.email,
        password: $scope.loginForm.password,
        success: function() {
          loadingService.hide();
          pushNotificationsService.initPush();
          return $state.go('app.contacts', {}, {
            location: 'replace'
          });
        },
        error: function() {
          return loadingService.hide();
        }
      });
    };
  }).controller('DeviseSignUpCtrl', function($scope, deviseService, $ionicLoading, $state) {
    $scope.signUpForm = {};
    $scope.signUpForm.email = "";
    $scope.signUpForm.password = "";
    $scope.signUpForm.password_confirmation = "";
    return $scope.signUp = function() {
      $ionicLoading.show({
        content: 'Creating the account'
      });
      return deviseService.signUp({
        email: $scope.signUpForm.email,
        password: $scope.signUpForm.password,
        password_confirmation: $scope.signUpForm.password_confirmation,
        success: function() {
          $ionicLoading.hide();
          return deviseService.loadSession({
            success: function() {
              return $state.go('app.contacts', {}, {
                location: 'replace'
              });
            }
          });
        },
        error: function() {
          return $ionicLoading.hide();
        }
      });
    };
  }).controller('DeviseSignOutCtrl', function($scope, deviseService, $ionicLoading, $state) {
    return deviseService.signOut({
      success: function() {
        return $state.go('sign_in', {}, {
          location: 'replace'
        });
      }
    });
  });

}).call(this);

(function() {
  var mapCtrl;

  mapCtrl = angular.module('mapsCtrl', ['google-maps']);

  mapCtrl.controller('MapCtrl', function($scope, $ionicLoading, $ionicPlatform) {
    var onError, onSuccess;
    $scope.title = 'Map';
    $scope.map = {
      center: {
        latitude: 45,
        longitude: -73
      },
      zoom: 8,
      markers: [
        {
          id: 1,
          coordinates: {
            latitude: 12,
            longitude: 42
          }
        }
      ]
    };
    onError = function(error) {
      alert("code: " + error.code + "\n" + "message: " + error.message + "\n");
    };
    onSuccess = function(position) {
      $ionicLoading.hide();
      $scope.map.center = {
        latitude: position.coords.latitude,
        longitude: position.coords.longitude
      };
      $scope.map.markers = [
        {
          id: 1,
          coordinates: {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude
          },
          options: {
            title: 'Your position'
          }
        }
      ];
      $scope.$apply();
    };
    return $scope.getPosition = function() {
      return $ionicPlatform.ready(function() {
        $ionicLoading.show({
          content: '<i class="icon ion-loading-c"></i> Getting your current location'
        });
        return navigator.geolocation.getCurrentPosition(onSuccess, onError);
      });
    };
  });

}).call(this);

(function() {
  var settingsCtrl;

  settingsCtrl = angular.module('settingsCtrl', ['settingsServices', 'applicationServices']);

  settingsCtrl.controller('SettingCtrl', function($scope, settingsService, $ionicPlatform, applicationService) {
    var setPictureData, user;
    $scope.title = 'Settings';
    user = applicationService.getUser();
    console.log(user);
    $scope.avatar = applicationService.getBackEndInfos() + user.avatar_url;
    $scope.takePicture = function() {
      return $ionicPlatform.ready(function() {
        return navigator.camera.getPicture(setPictureData, (function(message) {
          alert(message);
        }), {
          quality: 50,
          destinationType: navigator.camera.DestinationType.FILE_URI,
          sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
        });
      });
    };
    setPictureData = function(FILE_URI) {
      $scope.avatar = FILE_URI;
      return $scope.$apply();
    };
    return $scope.sendPicture = function() {
      var img;
      img = $scope.avatar;
      return settingsService.uploadAvatar(img, {
        success: function(r) {
          user.avatar_url = r.response;
          return applicationService.setUser(user);
        },
        error: function(r) {
          return alert('error');
        }
      });
    };
  });

}).call(this);

(function() {
  var usersCtrl;

  usersCtrl = angular.module('usersCtrl', ['usersServices']);

  usersCtrl.controller('UsersIndexCtrl', function($scope, usersService) {
    $scope.title = "All Users";
    $scope.users = {};
    return usersService.fetchUsers({
      success: function(data) {
        return $scope.users = data;
      }
    });
  }).controller('UserPageCtrl', function($scope, $stateParams, usersService) {
    $scope.other_user = {};
    return usersService.fetchUser({
      userId: $stateParams.userId,
      success: function(data) {
        return $scope.other_user = data;
      }
    });
  });

}).call(this);
