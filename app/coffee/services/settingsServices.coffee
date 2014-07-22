settingsServices = angular.module 'settingsServices', ['applicationServices', 'loadingServices']

settingsServices.service 'settingsService',  ($http, applicationService, loadingService) ->
 
  # win = (r) ->
  #   alert('Image sent')

 
  # fail = (error) ->
  #   alert "An error has occurred: Code = " + error.code
  #   return

  uploadAvatar : (imageURI, callbacks) ->
    backendUrl = applicationService.getBackEndInfos()
    
    options = new FileUploadOptions()
    options.fileKey = "avatar"
    options.fileName = imageURI.substr(imageURI.lastIndexOf("/") + 1)
    options.mimeType = "image/jpeg"
   
    ft = new FileTransfer()
    ft.onprogress = (progressEvent) -> 

      if (progressEvent.lengthComputable) 
        loadingService.show
          content: (progressEvent.loaded / progressEvent.total * 100).toFixed(0) + '%'
         
    success = (r) ->
      loadingService.hide()
      callbacks.success(r)
  

    ft.upload imageURI, encodeURI(backendUrl + "/users/edit_avatar"), success, callbacks.error, options
    return
 