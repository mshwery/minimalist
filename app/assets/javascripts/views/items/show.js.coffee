class listApp.Views.ItemsShow extends Backbone.View
  tagName: "li"
  className: 'cf'

  template: JST['items/show']

  events:
    "movestart"       : "startMove"
    "move"            : "checkDirection"
    "moveend"         : "stopMoveItem"
    "touchstart"      : "longTap"
    "touchend"        : "stopTap"
    #"swiperight"      : "markCompleted"
    "swipeleft"       : "markIncompleted"
    "click .toggle"   : "togglecompleted"
    "dblclick .view"  : "edit"
    "click a.destroy" : "clear"
    "keypress .edit"  : "updateOnEnter"
    "blur .edit"      : "close"

  initialize: ->
    @startX = @startY = 0
    @model.bind('change', this.render)
    @model.view = this

  render: =>
    $(@el).html( @template(@model.toJSON()) )
    $(@el).toggleClass "completed", @model.get("completed")
    @input = @$(".edit")
    return this

  togglecompleted: ->
    @model.toggle()

  startMove: (e) ->
    if listApp.isMobile()
      alert e.distX
      @startX = e.targetTouches[0].pageX || e.changedTouches[0].pageX
      @startY = e.targetTouches[0].pageY || e.changedTouches[0].pageY
      listApp.log @startX
    else
      @startX = e.pageX
      @startY = e.pageY

  checkDirection: =>
    if (@startX > @startY && @startX < -@startY) or (@startX < @startY && @startX > -@startY)
      e.preventDefault()
      return
    else
      @stopTap(e)

  moveItem: (e) =>
    mouse = if listApp.isMobile() then e.targetTouches[0] else e
    curX = mouse.pageX - @startX
    listApp.log curX
    #@curX = if e.originalEvent.touches then e.originalEvent.touches[0].pageX else e.distX # || e.originalEvent.changedTouches[0].pageX else e.distX

    # Moves item with the finger
    dist = @includeDrag(5)#(e.distX)
    if dist > 0 && dist < @widthPercentage(38) && !$(@el).hasClass('editing')
      $(@el).css('left', dist)

  widthPercentage: (num) ->
    return $(@el).outerWidth() * (num / 100)

  includeDrag: (distance) ->
    return drag = Math.round(distance / 2.25)

  longTap: =>
    @timer = null
    @timer = setTimeout((=> @edit()), 1500)

  stopTap: (e) =>
    clearTimeout(@timer) if @timer

  stopMoveItem: (e) ->
    # stops moving item with the finger
    if @includeDrag(e.distX) > @widthPercentage(30)
      $(@el).animate({'left': ''}, 300)#.trigger('swiperight')
      @markCompleted()
    else
      $(@el).animate({'left': ''}, 300)

    @startY = 0
    @startX = 0

  markIncompleted: ->
    @model.toggle() if @model.get("completed")

  markCompleted: ->
    @model.toggle() if !@model.get("completed")

  edit: =>
    $(@el).addClass("editing")
    @input.focus().val(@input.val())

  close: =>
    value = @input.val()
    @clear()  unless value
    @model.save({ description: value })
    $(@el).removeClass("editing")

  updateOnEnter: (e) =>
    @close()  if e.keyCode is 13

  clear: () ->
    @model.clear()
