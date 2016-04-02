class listApp.Views.ListModal extends Backbone.View
  className: 'modal-container'
  template: JST['lists/share-modal']

  events:
    "click .modal-overlay" : "remove"
    "keyup #email-address" : "onInputChange"
    "submit form" : "addContributors"

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
    @$submitButton = $(@el).find('button[type="submit"]')

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

  getEmails: (inputText) =>
    inputText.split(',').map((email) -> email.trim()).filter((email) -> email)

  onInputChange: (e) =>
    emails = @getEmails(e.target.value)

    if emails.length
      people = if emails.length > 1 then 'people' else 'person'
      @$submitButton.text('Add ' + emails.length + ' ' + people)
    else
      @$submitButton.text('Done')

  addContributors: (e) =>
    # prevent page reload on submit
    e.preventDefault()

    # grab the email input
    $emailInput = $(e.target).find('#email-address')

    # get emails in an array (if any)
    emails = @getEmails($emailInput.val())
    $emailInput.val('')

    # wait for all items to be created before closing the modal
    if emails.length
      closeModal = _.after(emails.length, @remove)

      emails.forEach (email) =>
        @collection.create({ email: email }, { wait: true, success: closeModal })
    else
      # close modal
      @remove()
