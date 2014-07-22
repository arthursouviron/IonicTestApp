loadServices = angular.module 'loadingServices', []

loadServices.service "loadingService", ($ionicLoading) ->
  show: (options = {}) ->
    icon = '<i class="icon ' + (options.icon || "ion-loading-c") + ' "></i>'
    content = ' ' + (options.content || 'Loading')


    $ionicLoading.show
      content: icon + content
      animation: "fade-in"
      showBackdrop: true
      showDelay: 300
    return

  hide: ->
    $ionicLoading.hide()
    return
