pushNotifications = angular.module 'pushNotificationsServices', ['applicationServices', 'conversationsServices']

pushNotifications.service 'pushNotificationsService',  ($rootScope, $http, applicationService, $ionicPlatform, conversationsService) ->

  

  # sendPushTMP : () ->
  #   backend_url = applicationService.getBackEndInfos()
  #   $http(
  #     method: 'POST'
  #     url: backend_url + "/users/register_push"
  #     dataType: 'json'
  #     format: 'jsonp'
  #     data:
  #       user:
  #         register_id_token: token
  #   ).success( (res) ->
  #     alert('SendToken Success')
  #   ).error( (res) ->
  #     alert('sendToken Error')
  #   )

  

  initPush : () ->
    user = applicationService.getUser()
    console.log(user)

    $ionicPlatform.ready ->

      sendRegisterID = (token) ->
        backend_url = applicationService.getBackEndInfos()
        $http(
          method: 'POST'
          url: backend_url + "/users/register_push"
          dataType: 'json'
          format: 'jsonp'
          data:
            user:
              register_id_token: token
        ).success( (res) ->
          console.log('sendtoken success')
        ).error( (res) ->
          alert('sendToken Error')
        )


      successHandler = (result) ->
        console.log ('success=' + result)

      errorHandler = (error) ->
        alert('error=' + error)

      ######### ANDROID ############
      window.onNotificationGCM = (e) ->
        if e.event == 'registered'
          sendRegisterID(e.regid)
        else if e.event == 'message'
          conversationsService.receiveMessage(e.message, e.payload.data.sender_id);
          
      ##############################


      ###########  IOS ############
      # tokenHandler = (result) ->
      #   alert('device token = ' + result)
          
      # window.onNotificationAPN = (e) ->
      #   if  e.alert 
      #     navigator.notification.alert(e.alert);
      #   if  e.sound 
      #     snd = new Media(e.sound);
      #     snd.play();
      #   if  e.badge 
      #     pushNotification.setApplicationIconBadgeNumber(successHandler, errorHandler, e.badge);
      
      #############################

      # pushNotification = window.plugins.pushNotification

      # if device.platform is "android" or device.platform is "Android" or device.platform is "amazon-fireos"
      #   pushNotification.register successHandler, errorHandler,
      #     senderID: '872299617457'
      #     ecb: "onNotificationGCM"

      # else
      #   alert('IOS ou autre')
      #   pushNotification.register tokenHandler, errorHandler,
      #     badge: "true"
      #     sound: "true"
      #     alert: "true"
      #     ecb: "onNotificationAPN"


  

  # unregisterToken : (token) ->

