# this is the actual selected list view
class listApp.Views.ListsShow extends Backbone.View
  className: "selected-list"
  template: JST['lists/show']

  events: 
    "dblclick #stats h2"  : "edit"
    "doubletap #stats h2" : "edit"   
    "keypress #stats .edit"      : "updateOnEnter"
    "blur #stats .edit"          : "close"
    "click .refresh"      : "refresh"
    "click .back"         : "nav"

  initialize: ->
    @model.on('change:name', @updateName)
    @render()

  render: =>
    $(@el).html(@template(
      url: @model.urlRoot
      name: @model.get('name')
      remaining: @model.items.remaining().length
    ))

    @app = if @model.get('demo') then '#demo' else '#app'
    $(@app).append $(@el)

    @input = @$("#stats .edit")
    $('.current').removeClass('current')
    $('#'+@model.get('slug')).addClass('current')

    @initItems()
    @renderNewItemForm()
    return this

  remove: () ->
    @model.unbind('change', @updateName)
    super()

  nav: (e) ->
    e.preventDefault()
    path = listApp.apiPrefix 'lists'
    listApp.router.navigate(path, {trigger: true}) if path

  updateName: =>
    @$('#stats h2').text(@model.get('name'))

  edit: =>
    @$("#stats").addClass("editing")
    @input.focus().val(@input.val()).select()

  close: =>
    value = @input.val()
    if value && value != @model.get('name')
      if @model.get('demo')
        @model.set({name: value})
      else
        @model.save({name: value}, {success: @setUrl})
    @$('#stats').removeClass("editing")

  setUrl: =>
    path = window.location.pathname.split("/").slice(0, -1).join("/")
    newPath = [path, @model.get('slug')].join("/")
    listApp.router.navigate(newPath)

  updateOnEnter: (e) =>
    if e.which is 13
      e.preventDefault()
      e.stopPropagation()
      @close()

  initItems: =>
    @itemView ||= new listApp.Views.ItemsIndex( collection: @model.items )

  renderNewItemForm: =>
    @newItemView ||= new listApp.Views.ItemsNew( collection: @model.items )

  # TODO evaluate this
  # clearCompleted: ->
  #   _.each(@model.items.completed(), (item) ->
  #     item.clear() if item.view
  #   )
  #   return false

  refresh: ->
    @$el.addClass('loading')

    # clear completed items (deletes them too)
    # @clearCompleted()

    # then fetch/sync with the server, there could be remote changes
    # use `reset: true` so that new sort order is manifested
    @model.items.fetch
      # add: true
      # remove: true
      # merge: true
      reset: true
      wait: true
      success: => @afterRefresh()

  afterRefresh: ->
    setTimeout((=> @$el.removeClass('loading')), 300)
