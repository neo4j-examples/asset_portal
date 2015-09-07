root_element_selector = '#change-object-permissions'

get_app = =>
  app = Ember.Application.create
    rootElement: root_element_selector

  app.Router = Ember.Router.extend
    location: 'none'

  app.ApplicationController = Ember.Controller.extend
    object: null
    user_and_group_search: null
    searching: false
    saving: false

    user_permissions: (->
      @get('object.user_permissions')
    ).property('object', 'object.user_permissions.[]')

    group_permissions: (->
      @get('object.group_permissions')
    ).property('object', 'object.group_permissions.[]')

    actions:
      set_object: (object) ->
        @set('object', object)

      update_permissions: ->
        @set('saving', true)
        object = @get('object')
        $.ajax
          url: "/authorizables/#{object.model_slug}/#{object.id}.json"
          method: 'PUT'
          contentType: 'application/json'
          data: JSON.stringify(object)
        .done (result) =>
          @send 'set_object', result
          @set('saving', false)

      add_user: (user, level) ->
        @get('user_permissions').pushObject(user: user, level: level)
        @set('user_and_group_search', null)

      remove_user_permission: (user_permission) ->
        @get('object.user_permissions').removeObject(user_permission)

      add_group: (group, level) ->
        @get('group_permissions').pushObject(group: group, level: level)
        @set('user_and_group_search', null)

      remove_group_permission: (group_permission) ->
        @get('object.group_permissions').removeObject(group_permission)


    user_and_group_results_present: (->
      @get('user_results').length || @get('group_results').length
    ).property('user_and_group_results')

    user_and_group_results: {users: [], groups: []}

    user_results: (->
      user_ids = _(@get('user_permissions')).chain().pluck('user').pluck('id').value()

      _(@get('user_and_group_results').users).reject((user) ->
        user.id in user_ids
      ).slice(0, 5)
    ).property('user_and_group_results', 'user_permissions.[]')

    group_results: (->
      group_ids = _(@get('group_permissions')).chain().pluck('group').pluck('id').value()

      _(@get('user_and_group_results').groups).reject((group) ->
        group.id in group_ids
      ).slice(0, 5)
    ).property('user_and_group_results', 'group_permissions.[]')

    debounced_query: ((controller, key) ->
      @set('searching', true)
      Ember.run.debounce @, @query, 400
    ).observes('user_and_group_search')

    query: (controller, key) ->
      query_string = @get('user_and_group_search')

      $.getJSON "/authorizables/user_and_group_search.json?query=#{query_string}", (result) =>
        @set('user_and_group_results', result)
        @set('searching', false)

    radio_button_name_for_user: (user) ->
      'user_level_' + user.id



  app.ApplicationRoute = Ember.Route.extend
    setupController: (controller, model) ->
      Ember.Instrumentation.subscribe 'set_object',
        before: (name, timestamp, payload) ->
          controller.send 'set_object', payload

        after: ->

  app.RadioButtonComponent = Ember.Component.extend
    tagName: 'input'
    type: 'radio'
    attributeBindings: [ 'checked', 'name', 'type', 'value' ]

    checked: Em.computed 'value', 'groupValue', ->
      @get('value') == @get('groupValue')

    change: ->
      @set('groupValue', @get('value'))

  app

# ready

$(document).on 'click', '[data-authorizable]', (event) ->
  object = $(event.target).closest('[data-authorizable]').data('authorizable')

  keys = Object.keys(object)
  return if keys.length > 1

  model_slug = keys[0]

  object = object[model_slug]

  $.get "/authorizables/#{model_slug}/#{object.id}.json"
    .done (object) ->
      Ember.Instrumentation.instrument('set_object', object)

      $('.ui.modal').modal(detachable: false)
      $('.ui.modal').modal('show')

ready = ->
  if window.current_user?.admin
    for authorizable_element in $('[data-authorizable]')
      $(authorizable_element).append '<i class="add user icon"/>'

  if $(root_element_selector).length
    window.PermissionsModalApp = get_app()

if !window.permissions_modal_loaded
  $(document).ready ready
  $(document).on 'page:load', ready

window.permissions_modal_loaded = true
