class listApp.Views.ItemsNew extends Backbone.View
  el: '#add-item'
  tagName: 'ul'
  template: JST['items/new']

  events:
    "keypress #new-item"  : "createOnEnter"
    "click #submit-new-item" : "createItem"

  initialize: ->
    @render()

  render: =>
    @$el.html( @template() )
    @input = @$("#new-item")

  newAttributes: ->
    return {
      description:  @input.val()
      sort_order:   @collection.nextOrder()
      completed:    false
    }

  createItem: (e) ->
    e.preventDefault()
    @collection.create( @newAttributes() ) if $.trim( @input.val() ).length
    @input.val('')

  createOnEnter: (e) ->
    return if (e.keyCode != 13)
    $("#submit-new-item").click() #@createItem()
