contactsCtrl = angular.module 'contactsCtrl', ['contactsServices']


contactsCtrl.controller( 'ContactIndexCtrl', ($scope, contactService) ->
  $scope.title = "Contacts"

  contactService.fetchContacts
    success: (data)->
      $scope.contacts = {}

      # for contact in data
      #   if $scope.contacts[data.last_name]

      $scope.contacts = data 



  $scope.deleteContact = (item) ->
    contactService.deleteContact
      contactId: item.id
      success: ->
        $scope.contacts.splice(item, 1)
      error: ->
        alert('error')

).controller( 'ContactPageCtrl', ($scope, $stateParams, contactService) ->
  $scope.contact = {}
  $scope.contact.first_name = ""
  $scope.contact.last_name = ""
  $scope.contact.email = ""
  $scope.title = "Single Contact"

  contactService.fetchContact
    contactId: $stateParams.contactId
    success: (data) ->
      $scope.contact = data


).controller( 'ContactNewCtrl', ($scope, contactService, $location) ->

  $scope.title = "New Contact"
  $scope.contactForm = {}
  $scope.contactForm.first_name = ""
  $scope.contactForm.last_name = ""
  $scope.contactForm.email = ""

  $scope.createContact = () ->
    contactService.saveContact
      data:
        first_name: $scope.contactForm.first_name
        last_name: $scope.contactForm.last_name
        email: $scope.contactForm.email
      success : ->
        $location.path('/app/contacts')

)