conversationsServices = angular.module 'conversationsServices', ['applicationServices']


conversationsServices.service 'conversationsService', ($rootScope, $ionicScrollDelegate, $http, $state, applicationService) ->


  fetchConversation : (options) ->
    session = applicationService.getSessionInfos()
    if session.user_id > 0
      $http(
        method: 'GET'
        url: session.backend_url + '/users/' + session.user_id + '/conversations/' + options.conversationId
        format: 'jsonp'
      ).success( (res) ->
        options.success(res)
      ).error( (res) ->
        options.error()
      )


  createConversation : (options) ->
    session = applicationService.getSessionInfos()
    $http(
      url: session.backend_url + '/users/' + session.user_id + '/conversations'
      method: 'POST'
      dataType: 'json'
      format: 'jsonp'
      data:
        conversation:
          contact_id: options.conversationId
    ).success( (res) ->
      options.success(res)
      
    ).error( (res) ->
      alert('error save')
    )


  sendMessage : (options) ->
    session = applicationService.getSessionInfos()
    $http(
      url: session.backend_url + '/users/' + session.user_id + '/conversations/' + options.conversationId + '/send_message'
      method: 'POST'
      dataType: 'json'
      format: 'jsonp'
      data:
        message:
          content: options.msg
    ).success( (res) ->
      options.success()
      
    ).error( (res) ->
      alert('error save')
    )

  receiveMessage : (msg, sender_id) ->
    # $rootScope.$broadcast('msgReceivedlol', {msg: msg, sender_id: sender_id})
    alert('RECEIVE')
    $state.go('app.conversation_details', {conversationId: sender_id, msg: msg}, {location: 'replace'})



