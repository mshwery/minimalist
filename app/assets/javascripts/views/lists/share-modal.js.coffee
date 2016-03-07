class listApp.Views.ListModal extends Backbone.View
  className: 'modal-container'
  template: JST['lists/share-modal']

  events:
    "click .modal-close" : "remove"
    "click .modal-overlay" : "remove"
    "keypress #email-address" : "addContributor"

  initialize: ->
    @collection.on('add', @renderContributor)
    @collection.on('reset', @renderContributors)
    @collection.on('remove', @renderContributors)
    @render()

  render: ->
    $(@el).html(@template())
    @$contributors = $(@el).find('.list-contributors')
    @renderContributors()
    $('#app').append($(@el).addClass('modal-is-shown'))

  renderContributors: =>
    @$contributors.empty()
    _.each(@collection.models, @renderContributor)

  renderContributor: (contributor) =>
    view = new listApp.Views.Contributor(model: contributor)
    @$contributors.append(view.render().el)

  remove: =>
    $el = $(@el)
    if $el.length && $el.hasClass('modal-is-shown')
      $el.removeClass('modal-is-shown').addClass('modal-closing')
      $el.one 'animationend webkitAnimationEnd oAnimationEnd', => 
        super()

  addContributor: (e) =>
    if e.which is 13
      e.preventDefault()
      e.stopPropagation()

      email = e.target.value.trim()
      @collection.create({email: email}, {wait: true}) if email.length
      $(e.target).val('').removeClass('dirty')

