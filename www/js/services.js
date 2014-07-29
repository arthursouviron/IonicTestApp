(function() {
  var applicationServices;

  applicationServices = angular.module('applicationServices', []);

  applicationServices.service('applicationService', function() {
    return {
      getBackEndInfos: function() {
        var backend_url;
        return backend_url = "http://192.168.0.3:3000";
      },
      getSessionInfos: function() {
        var session;
        return session = {
          user_id: window.localStorage.getItem('user_id'),
          user_token: window.localStorage.getItem('user_token'),
          user_email: window.localStorage.getItem('user_email'),
          token_url: 'user_email=' + window.localStorage.getItem('user_email') + '&user_token=' + window.localStorage.getItem('user_token'),
          backend_url: "http://192.168.0.3:3000"
        };
      },
      removeSessionInfos: function() {
        window.localStorage.removeItem('user_id');
        window.localStorage.removeItem('user_token');
        return window.localStorage.removeItem('user_email');
      },
      getUser: function() {
        return JSON.parse(window.localStorage.getItem('user'));
      },
      setUser: function(user) {
        return window.localStorage.setItem('user', JSON.stringify(user));
      }
    };
  });

}).call(this);

(function() {
  var contactsServices;

  contactsServices = angular.module('contactsServices', ['applicationServices']);

  contactsServices.service('contactService', function($http, applicationService) {
    return {
      deleteContact: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_id > 0) {
          return $http({
            method: 'DELETE',
            url: session.backend_url + '/users/' + session.user_id + '/contacts/' + options.contactId,
            format: 'jsonp'
          }).success(function(res) {
            return options.success();
          }).error(function() {
            alert('error delete');
            return options.error();
          });
        }
      },
      fetchContact: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_id > 0) {
          return $http({
            method: 'GET',
            url: session.backend_url + '/users/' + session.user_id + '/contacts/' + options.contactId,
            format: 'jsonp'
          }).success(function(res) {
            return options.success(res);
          }).error(function(res) {
            return alert('error fetch');
          });
        }
      },
      fetchContacts: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_id > 0) {
          return $http({
            method: 'GET',
            url: session.backend_url + '/users/' + session.user_id + '/contacts.json',
            format: 'jsonp'
          }).success(function(res) {
            return options.success(res);
          }).error(function(res) {
            return alert('error fetch');
          });
        }
      },
      saveContact: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        return $http({
          url: session.backend_url + '/users/' + session.user_id + '/contacts.json',
          method: 'POST',
          dataType: 'json',
          format: 'jsonp',
          data: {
            contact: {
              first_name: options.data.first_name,
              last_name: options.data.last_name,
              email: options.data.email
            }
          }
        }).success(function(res) {
          return options.success();
        }).error(function(res) {
          return alert('error save');
        });
      }
    };
  });

}).call(this);

(function() {
  var conversationsServices;

  conversationsServices = angular.module('conversationsServices', ['applicationServices']);

  conversationsServices.service('conversationsService', function($rootScope, $ionicScrollDelegate, $http, $state, applicationService) {
    return {
      fetchConversation: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_id > 0) {
          return $http({
            method: 'GET',
            url: session.backend_url + '/users/' + session.user_id + '/conversations/' + options.conversationId,
            format: 'jsonp'
          }).success(function(res) {
            return options.success(res);
          }).error(function(res) {
            return options.error();
          });
        }
      },
      createConversation: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        return $http({
          url: session.backend_url + '/users/' + session.user_id + '/conversations',
          method: 'POST',
          dataType: 'json',
          format: 'jsonp',
          data: {
            conversation: {
              contact_id: options.conversationId
            }
          }
        }).success(function(res) {
          return options.success(res);
        }).error(function(res) {
          return alert('error save');
        });
      },
      sendMessage: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        return $http({
          url: session.backend_url + '/users/' + session.user_id + '/conversations/' + options.conversationId + '/send_message',
          method: 'POST',
          dataType: 'json',
          format: 'jsonp',
          data: {
            message: {
              content: options.msg
            }
          }
        }).success(function(res) {
          return options.success();
        }).error(function(res) {
          return alert('error save');
        });
      },
      receiveMessage: function(msg, sender_id) {
        if ($state.current.name !== 'app.conversation_details') {
          return $state.go('app.conversation_details', {
            conversationId: sender_id,
            msg: msg
          }, {
            location: 'replace'
          });
        } else {
          return $rootScope.$broadcast('msgReceivedlol', {
            msg: msg,
            sender_id: sender_id
          });
        }
      }
    };
  });

}).call(this);

(function() {
  var deviseServices;

  deviseServices = angular.module('deviseServices', ['applicationServices']);

  deviseServices.service('deviseService', function($http, applicationService) {
    return {
      loadSession: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_email && session.user_token) {
          return $http({
            method: 'GET',
            url: session.backend_url + "/users/sign_in.json"
          }).success(function(res) {
            return options.success();
          }).error(function(res) {
            window.localStorage.clear();
            return options.error();
          });
        }
      },
      login: function(options) {
        var backendUrl;
        backendUrl = applicationService.getBackEndInfos();
        return $http({
          method: 'POST',
          url: backendUrl + "/users/sign_in.json",
          dataType: 'json',
          format: 'jsonp',
          data: {
            user: {
              email: options.email,
              password: options.password
            }
          }
        }).success(function(res) {
          if (res && res.success && res.user) {
            res.user.avatar_url = res.avatar_url;
            window.localStorage.setItem('user', JSON.stringify(res.user));
            window.localStorage.setItem('user_id', res.user.id);
            window.localStorage.setItem('user_token', res.user.authentication_token);
            window.localStorage.setItem('user_email', res.user.email);
            return options.success();
          } else {
            alert('Mot de passe/Email incorrect');
            return options.error();
          }
        }).error(function(data) {
          alert('error', data);
          return options.error();
        });
      },
      signOut: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        return $http({
          method: 'DELETE',
          url: session.backend_url + "/users/sign_out.json",
          dataType: 'json',
          format: 'jsonp'
        }).success(function(res) {
          applicationService.removeSessionInfos();
          return options.success();
        }).error(function(data) {
          return alert("ERREUR LOGOUT");
        });
      },
      signUp: function(options) {
        var backendUrl;
        backendUrl = applicationService.getBackEndInfos();
        return $http({
          method: 'POST',
          url: backendUrl + "/users",
          dataType: 'json',
          format: 'jsonp',
          data: {
            user: {
              email: options.email,
              password: options.password,
              password_confirmation: options.password_confirmation
            }
          }
        }).success(function(res) {
          if (res.data) {
            window.localStorage.clear();
            window.localStorage.setItem('user_id', res.data.id);
            window.localStorage.setItem('user_token', res.data.authentication_token);
            window.localStorage.setItem('user_email', res.data.email);
            return options.success();
          } else {
            alert(res.state.messages[0]);
            return options.error();
          }
        }).error(function(data) {
          return alert('error creation account');
        });
      }
    };
  });

}).call(this);

(function() {
  var loadServices;

  loadServices = angular.module('loadingServices', []);

  loadServices.service("loadingService", function($ionicLoading) {
    return {
      show: function(options) {
        var content, icon;
        if (options == null) {
          options = {};
        }
        icon = '<i class="icon ' + (options.icon || "ion-loading-c") + ' "></i>';
        content = ' ' + (options.content || 'Loading');
        $ionicLoading.show({
          content: icon + content,
          animation: "fade-in",
          showBackdrop: true,
          showDelay: 300
        });
      },
      hide: function() {
        $ionicLoading.hide();
      }
    };
  });

}).call(this);

(function() {
  var pushNotifications;

  pushNotifications = angular.module('pushNotificationsServices', ['applicationServices', 'conversationsServices']);

  pushNotifications.service('pushNotificationsService', function($rootScope, $http, applicationService, $ionicPlatform, conversationsService) {
    return {
      initPush: function() {
        var user;
        user = applicationService.getUser();
        console.log(user);
        return $ionicPlatform.ready(function() {
          var errorHandler, sendRegisterID, successHandler;
          sendRegisterID = function(token) {
            var backend_url;
            backend_url = applicationService.getBackEndInfos();
            return $http({
              method: 'POST',
              url: backend_url + "/users/register_push",
              dataType: 'json',
              format: 'jsonp',
              data: {
                user: {
                  register_id_token: token
                }
              }
            }).success(function(res) {
              return console.log('sendtoken success');
            }).error(function(res) {
              return alert('sendToken Error');
            });
          };
          successHandler = function(result) {
            return console.log('success=' + result);
          };
          errorHandler = function(error) {
            return alert('error=' + error);
          };
          return window.onNotificationGCM = function(e) {
            if (e.event === 'registered') {
              return sendRegisterID(e.regid);
            } else if (e.event === 'message') {
              return conversationsService.receiveMessage(e.message, e.payload.data.sender_id);
            }
          };
        });
      }
    };
  });

}).call(this);

(function() {
  var settingsServices;

  settingsServices = angular.module('settingsServices', ['applicationServices', 'loadingServices']);

  settingsServices.service('settingsService', function($http, applicationService, loadingService) {
    return {
      uploadAvatar: function(imageURI, callbacks) {
        var backendUrl, ft, options, success;
        backendUrl = applicationService.getBackEndInfos();
        options = new FileUploadOptions();
        options.fileKey = "avatar";
        options.fileName = imageURI.substr(imageURI.lastIndexOf("/") + 1);
        options.mimeType = "image/jpeg";
        ft = new FileTransfer();
        ft.onprogress = function(progressEvent) {
          if (progressEvent.lengthComputable) {
            return loadingService.show({
              content: (progressEvent.loaded / progressEvent.total * 100).toFixed(0) + '%'
            });
          }
        };
        success = function(r) {
          loadingService.hide();
          return callbacks.success(r);
        };
        ft.upload(imageURI, encodeURI(backendUrl + "/users/edit_avatar"), success, callbacks.error, options);
      }
    };
  });

}).call(this);

(function() {
  var usersServices;

  usersServices = angular.module('usersServices', ['applicationServices']);

  usersServices.service('usersService', function($http, applicationService) {
    return {
      fetchUser: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_id > 0) {
          return $http({
            method: 'GET',
            url: session.backend_url + '/users/' + options.userId,
            format: 'jsonp'
          }).success(function(res) {
            return options.success(res);
          }).error(function(res) {
            return alert('error fetch');
          });
        }
      },
      fetchUsers: function(options) {
        var session;
        session = applicationService.getSessionInfos();
        if (session.user_id > 0) {
          return $http({
            method: 'GET',
            url: session.backend_url + '/users',
            format: 'jsonp'
          }).success(function(res) {
            return options.success(res);
          }).error(function(res) {
            return alert('error fetch');
          });
        }
      }
    };
  });

}).call(this);
