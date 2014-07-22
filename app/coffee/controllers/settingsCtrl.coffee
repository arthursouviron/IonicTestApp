settingsCtrl = angular.module 'settingsCtrl', ['settingsServices', 'applicationServices']

settingsCtrl.controller 'SettingCtrl', ($scope, settingsService, $ionicPlatform, applicationService) ->
  $scope.title = 'Settings'
  user = applicationService.getUser()
  
  console.log(user)
  $scope.avatar = applicationService.getBackEndInfos() + user.avatar_url

  $scope.takePicture = () ->
    $ionicPlatform.ready ->
      navigator.camera.getPicture setPictureData, ((message) ->
        alert message
        return
      ),
        quality: 50
        destinationType: navigator.camera.DestinationType.FILE_URI
        sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY

  setPictureData = (FILE_URI) ->
      # alert(FILE_URI)
    # alert(FILE_URI)
    #$scope.avatar = "data:image/jpeg;base64," + FILE_URI
    $scope.avatar = FILE_URI
    $scope.$apply()
    # $scope.$apply()
    # settingsService.uploadAvatar(FILE_URI)


  $scope.sendPicture = () ->
    img = $scope.avatar
    settingsService.uploadAvatar(img, {
      success: (r) ->

        user.avatar_url = r.response
        applicationService.setUser(user)
      error: (r) ->
        alert('error')

    })