deviseCtrl = angular.module 'deviseCtrl', ['deviseServices', 'loadingServices', 'pushNotificationsServices']

deviseCtrl.controller( 'DeviseLoginCtrl', ($scope, $location, deviseService, loadingService, $state, pushNotificationsService) ->
  $scope.title = 'TITELU'
  $scope.loginForm = {}
  # $scope.loginForm.email = "test@test.com"
  # $scope.loginForm.password = "password"

  deviseService.loadSession
    success: () ->
      pushNotificationsService.initPush()
      $state.go('app.contacts', {}, {location: 'replace'})


  $scope.login = () ->
    loadingService.show
      content: 'Logging in'
    deviseService.login
      email: $scope.loginForm.email
      password: $scope.loginForm.password
      success: ->
        loadingService.hide()
        # $location.path('/app/contacts')
        pushNotificationsService.initPush()
        $state.go('app.contacts', {}, {location: 'replace'})
      error: ->
        loadingService.hide()


        #Redirect to contact index

).controller( 'DeviseSignUpCtrl', ($scope, deviseService, $ionicLoading, $state) ->

  $scope.signUpForm = {}
  $scope.signUpForm.email = ""
  $scope.signUpForm.password = ""
  $scope.signUpForm.password_confirmation = ""

  $scope.signUp = () ->
    $ionicLoading.show
      content: 'Creating the account'
    deviseService.signUp
      email: $scope.signUpForm.email
      password: $scope.signUpForm.password
      password_confirmation: $scope.signUpForm.password_confirmation
      success: ->
        $ionicLoading.hide()
        deviseService.loadSession
          success: () ->
            $state.go('app.contacts', {}, {location: 'replace'})
      error: ->
        $ionicLoading.hide()

).controller( 'DeviseSignOutCtrl', ($scope, deviseService, $ionicLoading, $state) ->

  deviseService.signOut
    success: () ->
      $state.go('sign_in', {}, {location: 'replace'})
)



