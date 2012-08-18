class listApp.Views.ListsShow extends Backbone.View
  el: '#listapp'
  template: JST['lists/show']

  events:
    "move" : "startMoveItem"
    "moveend" : "stopMoveItem" 
    "click #stats h2": "edit"   
    "keypress .edit"  : "updateOnEnter"
    "blur .edit"      : "close"

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
    @spinner = @$(".loading")
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
    if value
      @model.save({ name: value })
      @$('#stats').removeClass("editing")

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

  startMoveItem: (e) ->
    if (e.distX > e.distY && e.distX < -e.distY) or (e.distX < e.distY && e.distX > -e.distY)
      e.preventDefault()
      dist = @includeDrag(e.distY)
      if dist > 0 && dist < 50
        @$el.css('top', dist)
      return

  includeDrag: (distance) ->
    return drag = Math.round(distance / 2.25)     

  stopMoveItem: (e) =>
    if @includeDrag(e.distY) > 40
      @spinner.toggle()
      @model.items.fetch
        add: true
        success: => @afterRefresh()
    else
      @$el.animate({'top': 0}, 200)

  afterRefresh: ->
    @clearCompleted()
    @spinner.toggle()
    @$el.animate({'top': 0}, 200) 
