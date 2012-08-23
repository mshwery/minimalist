class listApp.Views.ItemsShow extends Backbone.View
  tagName: "li"
  className: 'cf'

  template: JST['items/show']

  events:
    "movestart"       : "checkDirection"
    "move"            : "moveItem"
    "moveend"         : "stopMoveItem"
    "touchstart"      : "longTap"
    "touchend"        : "stopTap"
    "swiperight"      : "markCompleted"
    "swipeleft"       : "markIncompleted"
    "click .toggle"   : "togglecompleted"
    "dblclick .view"  : "edit"
    "click a.destroy" : "clear"
    "keypress .edit"  : "updateOnEnter"
    "keyup .edit"     : "limitChars"
    "blur .edit"      : "close"

  initialize: ->
    @model.bind('change:description', this.render)
    @model.view = this

  render: =>
    $(@el).html( @template(@model.toJSON()) )
    $(@el).toggleClass "completed", @model.get("completed")
    @input = @$(".edit")
    @input.autogrow({expandTolerance:0})
    return this

  togglecompleted: ->
    @model.toggle()
    @$el.toggleClass('completed')

  checkDirection: (e) ->
    @stopTap()
    if (e.distX > e.distY && e.distX < -e.distY) or (e.distX < e.distY && e.distX > -e.distY)
      e.preventDefault()
      return

  moveItem: (e) ->
    e.preventDefault()
    
    # Moves item with the finger
    dist = @includeDrag(e.distX)
    if dist > 0 && dist < @widthPercentage(30) && $(@el).not('.editing, .completed')
      @$el.css('left', dist)

  widthPercentage: (num) ->
    return $(@el).outerWidth() * (num / 100)

  includeDrag: (distance) ->
    return drag = Math.round(distance / 2.25)

  longTap: ->
    @timer = null
    @timer = setTimeout((=> @edit()), 1000)

  stopTap: ->
    clearTimeout(@timer) if @timer

  stopMoveItem: (e) ->
    @direction = null
    # stops moving item with the finger
    if @includeDrag(e.distX) > @widthPercentage(28)
      @$el.animate({'left': ''}, 300)
      @markCompleted()
    else
      @$el.animate({'left': ''}, 100)

  markIncompleted: ->
    @$el.removeClass('completed')
    @model.toggle() if @model.get("completed")
    @$('.toggle').attr('checked', false)

  markCompleted: ->
    @$el.addClass('completed')
    @model.toggle() if !@model.get("completed")
    @$('.toggle').attr('checked', true)

  edit: =>
    @$el.addClass("editing")
    @input.focus().val(@input.val())

  close: =>
    value = @input.val()
    if value
      @model.save({ description: value })
      @$el.removeClass("editing")
    else 
      @clear()

  limitChars: (e) =>
    unless @input.val().length < $(e.target).attr('maxlength')
      e.preventDefault()

  updateOnEnter: (e) =>
    @close()  if e.keyCode is 13

  clear: () ->
    @model.clear()
