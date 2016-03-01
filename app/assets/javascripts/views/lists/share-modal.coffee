class listApp.Views.ListModal extends Backbone.View
  className: 'modal-container'
  template: JST['lists/share-modal']

  events:
    "click .modal-close" : "remove"
    "click .modal-overlay" : "remove"
    "keypress #email-address" : "stageShareUser"

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(
      contributors: @collection.models
    ))
    $('#app').append($(@el).addClass('modal-is-shown'))

  remove: =>
    $el = $(@el)
    if $el.length && $el.hasClass('modal-is-shown')
      $el.removeClass('modal-is-shown').addClass('modal-closing')
      $el.one 'animationend webkitAnimationEnd oAnimationEnd', => 
        super()

  stageShareUser: (e) =>
    if e.which is 13
      e.preventDefault()
      e.stopPropagation()

      email = e.target.value.trim()
      @collection.create(email: email) if email.length
      $(e.target).val('').removeClass('dirty')
