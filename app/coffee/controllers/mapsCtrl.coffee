mapCtrl = angular.module 'mapsCtrl', [ 'google-maps']

mapCtrl.controller 'MapCtrl', ($scope, $ionicLoading, $ionicPlatform) ->
  $scope.title = 'Map'
  
  
  $scope.map = 
    center: 
      latitude: 45
      longitude: -73
    zoom: 8
    markers: [ 
      id: 1
      coordinates:
        latitude: 12
        longitude: 42
    ]

  onError = (error) ->
    alert "code: " + error.code + "\n" + "message: " + error.message + "\n"
    return
  onSuccess = (position) ->
    $ionicLoading.hide()
    $scope.map.center =
      latitude: position.coords.latitude
      longitude: position.coords.longitude
    $scope.map.markers =  [
      id: 1
      coordinates:
        latitude: position.coords.latitude
        longitude: position.coords.longitude
      options:
        title: 'Your position'
    ]
    $scope.$apply()
    return

  $scope.getPosition = () ->
    $ionicPlatform.ready ->
      $ionicLoading.show(
        content: '<i class="icon ion-loading-c"></i> Getting your current location'
      )
      navigator.geolocation.getCurrentPosition onSuccess, onError