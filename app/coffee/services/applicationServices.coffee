applicationServices = angular.module 'applicationServices', []



applicationServices.service 'applicationService', () ->

  getBackEndInfos : () ->
    #backend_url = "http://localhost:3000"
    #backend_url = "http://rails-api-for-ionic.herokuapp.com"
    backend_url = "http://192.168.0.3:3000"
    #backend_url = "http://192.168.1.46:3000"


  getSessionInfos : () ->
    session = {
      user_id: window.localStorage.getItem('user_id')
      user_token: window.localStorage.getItem('user_token')
      user_email: window.localStorage.getItem('user_email')
      token_url: 'user_email=' + window.localStorage.getItem('user_email') + '&user_token=' + window.localStorage.getItem('user_token')
      #backend_url: "http://localhost:3000"
      #backend_url: "http://rails-api-for-ionic.herokuapp.com"
      backend_url: "http://192.168.0.3:3000"
      #backend_url: "http://192.168.1.46:3000" 
    }

  removeSessionInfos : () ->
    window.localStorage.removeItem('user_id')
    window.localStorage.removeItem('user_token')
    window.localStorage.removeItem('user_email')

  # setSessionInfos : (options) ->
  #   console.log "SET OPTION"
  #   console.log options
  #   window.localStorage.setItem('user_id', options.user_id)
  #   window.localStorage.setItem('user_token', options.authentication_token)
  #   window.localStorage.setItem('user_email', options.email)
  #   options.success()

  getUser : () ->
    return JSON.parse(window.localStorage.getItem('user'))

  setUser : (user) ->
    window.localStorage.setItem('user', JSON.stringify(user))