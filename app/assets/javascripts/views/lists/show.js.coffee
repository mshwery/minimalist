class listApp.Views.ListsShow extends Backbone.View
  el: '#listapp'
  template: JST['lists/show']

  events: 
    "dblclick #stats h2"  : "edit"
    "doubletap #stats h2" : "edit"   
    "keypress .edit"      : "updateOnEnter"
    "blur .edit"          : "close"
    "click .refresh"      : "refresh"

  initialize: ->
    @model.items.on("change", @updateCount)
    @model.items.on("add", @updateCount)
    @model.on('change:name', @updateName)

    @model.fetch
      success: (response) =>
        @render()

  render: =>
    $(@el).html(@template(
      url: @model.urlRoot
      name: @model.get('name')
      remaining: @model.items.remaining().length
    ))
    @input = @$("#stats .edit")

    @initItems()
    @updateCount()
    @renderNewItemForm()

  updateCount: =>
    @$('#stats i').text(@model.items.remaining().length)

  updateName: =>
    @$('#stats h2').text(@model.get('name'))

  edit: =>
    @$("#stats").addClass("editing")
    @input.focus().val(@input.val())

  close: =>
    value = @input.val()
    if value && value != @model.get('name')
      if @model.get('demo')
        @model.set({name: value})
      else
        @model.save({name: value, slug: @model.get('slug')}, {success: @setUrl})
    @$('#stats').removeClass("editing")

  setUrl: =>
    path = window.location.pathname.split("/").slice(0, -1).join("/")
    newPath = [path, @model.get('slug')].join("/")
    listApp.router.navigate(newPath)

  updateOnEnter: (e) =>
    @close()  if e.keyCode is 13

  initItems: =>
    @itemView ||= new listApp.Views.ItemsIndex( collection: @model.items )

  renderNewItemForm: =>
    @newItemView ||= new listApp.Views.ItemsNew( collection: @model.items )

  clearCompleted: ->
    _.each(@model.items.completed(), (item) ->
      item.clear() if item.view
    )
    return false

  refresh: ->
    @$el.addClass('loading')
    @model.items.fetch
      add: true
      wait: true
      success: => @afterRefresh()

  afterRefresh: ->
    @clearCompleted()
    setTimeout((=> @$el.removeClass('loading')), 300)
