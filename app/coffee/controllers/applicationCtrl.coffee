appCtrl = angular.module 'applicationCtrl', ['ionic']

appCtrl.controller 'AppCtrl', ($rootScope, loadingService) ->
  # $scope.title = 'AppCtrl'

  # $scope.toggleSideMenu = () ->
  #   $ionicSideMenuDelegate.toggleLeft();]


  $rootScope.$on 'showLoading', () ->
    loadingService.show()
  
  $rootScope.$on 'hideLoading', () ->
    loadingService.hide()

