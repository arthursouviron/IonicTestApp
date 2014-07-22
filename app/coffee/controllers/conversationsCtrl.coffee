conversationsCtrl = angular.module 'conversationsCtrl', ['conversationsServices', 'pushNotificationsServices', 'applicationServices']


conversationsCtrl.controller( 'conversationsIndexCtrl', ($scope, conversationsService) ->
 
  $scope.title = "All conversations"

  $scope.conversations = {}

  conversationsService.fetchConversations
    success : (data) ->
      $scope.conversations = data

).controller( 'ConversationPageCtrl', ($rootScope, $scope, $stateParams, conversationsService, $ionicScrollDelegate, pushNotificationsService, applicationService) ->

  $scope.conversation = {}
  $scope.conversation.messages = []
  $scope.msgInput = ""
  $scope.user = applicationService.getUser()

  createConversation = () ->
    conversationsService.createConversation
      conversationId: $stateParams.conversationId
      success: () ->
        $scope.conversation.message = []
      error: () ->
        alert('error create convers')


  conversationsService.fetchConversation
    conversationId: $stateParams.conversationId
    success: (data) ->
      #Conversation already exist, display existing msg
      console.log(data)
      if !data.length 
        createConversation()

      $scope.conversation.messages = data.messages
    error: () ->
      createConversation()
      #conversation doesnt exist, create it
     


  $rootScope.$on 'msgReceivedlol', (scope, obj) ->
    message = {content: obj.msg, sender_id: obj.sender_id, destination_id: $scope.user.id}
    # $state.go('app.conversation_details', {}, {location: 'replace'})
    $scope.conversation.messages.push(angular.extend({}, message))
    $ionicScrollDelegate.scrollBottom(true);

    # # $ionicFrostedDelegate.update();


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
        $ionicScrollDelegate.scrollBottom(true);

      error: () ->
        alert('ERROR CREATE MSG')





  
)