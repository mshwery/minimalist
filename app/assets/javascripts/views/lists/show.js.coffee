class listApp.Views.ListsShow extends Backbone.View
  el: "#app"
  template: JST['lists/show']

  events: 
    "dblclick #stats h2"  : "edit"
    "doubletap #stats h2" : "edit"   
    "keypress #stats .edit"      : "updateOnEnter"
    "blur #stats .edit"          : "close"
    "click .refresh"      : "refresh"
    "click .back"         : "nav"

  initialize: ->
    @model.items.on("change", @updateCount)
    @model.items.on("add", @updateCount)
    @model.on('change:name', @updateName)

    @model.fetch
      success: (response) =>
        @render()

  render: =>
    $(@el).append(@template(
      url: @model.urlRoot
      name: @model.get('name')
      remaining: @model.items.remaining().length
    ))
    @input = @$("#stats .edit")

    $('.current').removeClass('current')
    $('#'+@model.get('slug')).addClass('current')

    @initItems()
    @updateCount()
    @renderNewItemForm()
    return this

  nav: (e) ->
    e.preventDefault()
    path = listApp.apiPrefix 'lists'
    listApp.router.navigate(path, {trigger: true}) if path

  updateCount: =>
    @$('#stats i').text(@model.items.remaining().length)

  updateName: =>
    @$('#stats h2').text(@model.get('name'))

  edit: =>
    @$("#stats").addClass("editing")
    @input.focus().val(@input.val())

  close: =>
    value = @input.val()
    listApp.log value + " : " + @model.get('slug')
    if value && value != @model.get('name')
      listApp.log 'saved!'
      if @model.get('demo')
        @model.set({name: value})
      else
        @model.save({name: value, slug: @model.get('slug')}, {success: @setUrl})
    @$('#stats').removeClass("editing")

  setUrl: =>
    listApp.log 'seturl'
    path = window.location.pathname.split("/").slice(0, -1).join("/")
    newPath = [path, @model.get('slug')].join("/")
    listApp.log 'seturl -> ' + newPath
    listApp.router.navigate(newPath)

  updateOnEnter: (e) =>
    if e.which is 13
      e.preventDefault()
      @close()

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
