usersServices = angular.module 'usersServices', ['applicationServices']


usersServices.service 'usersService', ($http, applicationService) ->



  fetchUser : (options) ->
    session = applicationService.getSessionInfos()
    if session.user_id > 0
      $http(
        method: 'GET'
        url: session.backend_url + '/users/' + options.userId
        format: 'jsonp'
      ).success( (res) ->
        options.success(res)
      ).error( (res) ->
        alert('error fetch')
      )


  fetchUsers : (options) ->
    session = applicationService.getSessionInfos()
    if session.user_id > 0
      $http(
        method: 'GET'
        url: session.backend_url + '/users'
        format: 'jsonp'
      ).success( (res) ->
        options.success(res)
      ).error( (res) ->
        alert('error fetch')
      )