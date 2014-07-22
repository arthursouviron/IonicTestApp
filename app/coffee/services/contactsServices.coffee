contactsServices = angular.module 'contactsServices', ['applicationServices']


contactsServices.service 'contactService', ($http, applicationService) ->

  deleteContact : (options) ->
    session = applicationService.getSessionInfos()
    if session.user_id > 0
      $http(
        method: 'DELETE'
        url: session.backend_url + '/users/' + session.user_id + '/contacts/' + options.contactId 
        format: 'jsonp'      
      ).success( (res) ->
        options.success()
      ).error( () ->
        alert('error delete')
        options.error()
      )

  fetchContact : (options) ->
    session = applicationService.getSessionInfos()
    if session.user_id > 0
      $http(
        method: 'GET'
        url: session.backend_url + '/users/' + session.user_id + '/contacts/' + options.contactId 
        format: 'jsonp'
      ).success( (res) ->
        options.success(res)
      ).error( (res) ->
        alert('error fetch')
      )


  fetchContacts : (options) ->
    session = applicationService.getSessionInfos()
    if session.user_id > 0
      $http(
        method: 'GET'
        url: session.backend_url + '/users/' + session.user_id + '/contacts.json'
        format: 'jsonp'
      ).success( (res) ->
        options.success(res)
      ).error( (res) ->
        alert('error fetch')
      )

  saveContact : (options) ->
    session = applicationService.getSessionInfos()
    $http(
      url: session.backend_url + '/users/' + session.user_id + '/contacts.json'
      method: 'POST'
      dataType: 'json'
      format: 'jsonp'
      data:
        contact:
          first_name: options.data.first_name
          last_name: options.data.last_name
          email: options.data.email
    ).success( (res) ->
      options.success()
      
    ).error( (res) ->
      alert('error save')
    )