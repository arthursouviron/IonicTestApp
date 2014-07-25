conversationsCtrl = angular.module 'conversationsCtrl', ['conversationsServices', 'pushNotificationsServices', 'applicationServices']


conversationsCtrl.controller( 'conversationsIndexCtrl', ($scope, conversationsService) ->
 
  $scope.title = "All conversations"

  $scope.conversations = {}

  conversationsService.fetchConversations
    success : (data) ->
      $scope.conversations = data

).controller( 'ConversationPageCtrl', ($scope, $stateParams, conversationsService, $ionicScrollDelegate, pushNotificationsService, applicationService) ->

  $scope.conversation = {}
  $scope.msgInput = ""
  $scope.user = applicationService.getUser()

  createConversation = () ->
    conversationsService.createConversation
      conversationId: $stateParams.conversationId
      success: (data) ->
        $scope.conversation = data
        $scope.conversation.messages = []
      error: () ->
        alert('error create convers')

  receiveMsg = (options) ->
    alert('receive')
    alert $scope.conversation
    message = {content: options.msg, sender_id: options.sender_id, destination_id: $scope.user.id}
    if !$scope.conversation.messages
      $scope.conversation.messages = []
    $scope.conversation.messages.push(angular.extend({}, message))
    $ionicScrollDelegate.scrollBottom(true)




  # $scope.$on 'msgReceivedlol', (scope, obj) ->
  #   alert('on')
  #   alert $scope.conversation
  #   message = {content: obj.msg, sender_id: obj.sender_id, destination_id: $scope.user.id}
  #   # $state.go('app.conversation_details', {}, {location: 'replace'})
  #   if !$scope.conversation.messages
  #     $scope.conversation.messages = []
  #   $scope.conversation.messages.push(angular.extend({}, message))
  #   $ionicScrollDelegate.scrollBottom(true)

    # # $ionicFrostedDelegate.update();

  conversationsService.fetchConversation
    conversationId: $stateParams.conversationId
    success: (data) ->
      #Conversation already exist, display existing msg
      console.log(data)
      if !data.conversation
        createConversation()
      else
        $scope.conversation.messages = data.messages
        $ionicScrollDelegate.scrollBottom(true)
        if $stateParams.msg
          alert('THERE IS MSG')
          receiveMsg({msg: $stateParams.msg, sender_id: $stateParams.conversationId})
          # $scope.$broadcast('msgReceivedlol', {msg: $stateParams.msg, sender_id: sender_id})




    error: () ->
      createConversation()
      #conversation doesnt exist, create it
     


  


  $scope.sendMessage = () ->
    conversationsService.sendMessage
      msg: $scope.msgInput
      conversationId: $stateParams.conversationId
      success: () ->
        message = {content: $scope.msgInput, sender_id: $scope.user.id, destination_id: $stateParams.conversationId}
        $scope.conversation.messages.push(angular.extend({}, message))
        console.log(message)
        # $ionicFrostedDelegate.update();
        $scope.msgInput = ""
        $ionicScrollDelegate.scrollBottom(true)

      error: () ->
        alert('ERROR CREATE MSG')





  
)