
EmberENV = {FEATURES: {'_ENABLE_LEGACY_VIEW_SUPPORT': true}};


window.UserListDropdownApp = Ember.Application.create
  rootElement: '#user-list-dropdown'

window.UserListDropdownApp.ApplicationView = Ember.View.extend
    templateName: 'user-list-dropdown', 
    
window.UserListDropdownApp.Router = Ember.Router.extend
  location: 'none'

window.UserListDropdownApp.ApplicationController = Ember.Controller.extend
  users: [{id: 22, name: 'Stacey'}]

  actions:
    test: ->
      $.get("/groups/#{}/users_to_add.json")


$(document).ready ->
