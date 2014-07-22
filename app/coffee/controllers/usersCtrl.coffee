usersCtrl = angular.module 'usersCtrl', ['usersServices']


usersCtrl.controller( 'UsersIndexCtrl', ($scope, usersService) ->
 
  $scope.title = "All Users"

  $scope.users = {}

  usersService.fetchUsers
    success : (data) ->
      $scope.users = data

).controller( 'UserPageCtrl', ($scope, $stateParams, usersService) ->

  $scope.other_user = {}

  usersService.fetchUser
    userId: $stateParams.userId
    success : (data) ->
      $scope.other_user = data
)