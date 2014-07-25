deviseServices = angular.module 'deviseServices', ['applicationServices']

deviseServices.service 'deviseService', ($http, applicationService) ->

  loadSession : (options) ->
    session = applicationService.getSessionInfos()    
    if session.user_email && session.user_token
      $http(
        method: 'GET'
        url: session.backend_url + "/users/sign_in.json"
      ).success( (res) ->
        options.success()
      ).error( (res) ->
        window.localStorage.clear()
        options.error()
      )


  login : (options) ->
    backendUrl = applicationService.getBackEndInfos()
   

    $http(
      method: 'POST'
      url: backendUrl + "/users/sign_in.json"
      dataType: 'json'
      format: 'jsonp'
      data:
        user:
          email: options.email
          password: options.password
    ).success( (res) ->
      if res && res.success && res.user
        res.user.avatar_url = res.avatar_url
        window.localStorage.setItem('user', JSON.stringify(res.user))
        window.localStorage.setItem('user_id', res.user.id)
        window.localStorage.setItem('user_token', res.user.authentication_token)
        window.localStorage.setItem('user_email', res.user.email)
        # applicationService.setSessionInfos
        #   user_id: res.user.id
        #   user_token: res.user.authentication_token
        #   user_email: res.user.email
        #   success: ->
        options.success()
      else
        alert 'Mot de passe/Email incorrect'
        options.error()

    ).error( (data) ->
      alert 'error', data
      options.error()

    )

  signOut : (options) ->
    session = applicationService.getSessionInfos()

    $http(
      method: 'DELETE'
      url: session.backend_url + "/users/sign_out.json"
      dataType: 'json'
      format: 'jsonp'
      
    ).success( (res) ->
      applicationService.removeSessionInfos()
      options.success()
    
    ).error( (data) ->
      alert "ERREUR LOGOUT"
    )

  signUp : (options) ->
    backendUrl = applicationService.getBackEndInfos()
    
    $http(
      method: 'POST'
      url: backendUrl + "/users"
      dataType: 'json'
      format: 'jsonp'
      data:
        user:
          email: options.email
          password: options.password
          password_confirmation: options.password_confirmation
    ).success( (res) ->
      if res.data
        window.localStorage.clear()
        window.localStorage.setItem('user_id', res.data.id)
        window.localStorage.setItem('user_token', res.data.authentication_token)
        window.localStorage.setItem('user_email', res.data.email)
        options.success()
      else
        alert(res.state.messages[0])
        options.error()

    ).error( (data) ->
      alert 'error creation account'
    )
