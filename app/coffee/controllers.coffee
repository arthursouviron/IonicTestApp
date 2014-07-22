
# Form data for the login modal

# Create the login modal that we will use later

# Triggered in the login modal to close it

# Open the login modal

# Perform the login action when the user submits the login form

# Simulate a login delay. Remove this and replace with your login
# code if using a login system
# angular.module("starter.controllers", []).controller("AppCtrl", ($scope, $ionicModal, $timeout) ->
#   $scope.loginData = {}
#   $ionicModal.fromTemplateUrl("templates/login.html",
#     scope: $scope
#   ).then (modal) ->
#     $scope.modal = modal
#     return

#   $scope.closeLogin = ->
#     $scope.modal.hide()
#     return

#   $scope.login = ->
#     $scope.modal.show()
#     return


#   $scope.doLogin = ->
#     console.log "Doing login", $scope.loginData
#     $timeout (->
#       $scope.closeLogin()
#       return
#     ), 1000
#     return

#   return
# ).controller("PlaylistsCtrl", ($scope) ->
#   $scope.playlists = [
#     {
#       title: "Reggae"
#       id: 1
#     }
#     {
#       title: "Chill"
#       id: 2
#     }
#     {
#       title: "Dubstep"
#       id: 3
#     }
#     {
#       title: "Indie"
#       id: 4
#     }
#     {
#       title: "Rap"
#       id: 5
#     }
#     {
#       title: "Cowbell"
#       id: 6
#     }
#   ]
#   return
# ).controller "PlaylistCtrl", ($scope, $stateParams) ->