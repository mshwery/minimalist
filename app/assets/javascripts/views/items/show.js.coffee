class listApp.Views.ItemsShow extends Backbone.View
  tagName: "li"
  className: 'cf'

  template: JST['items/show']

  events:
    "movestart"       : "checkDirection"
    "swiperight"      : "markCompleted"
    "swipeleft"       : "markIncompleted"
    "click .toggle"   : "togglecompleted"
    "dblclick .view"  : "edit"
    "doubletap .view" : "edit"
    "click a.destroy" : "clear"
    "keypress .edit"  : "updateOnEnter"
    "keyup .edit"     : "limitChars"
    "blur .edit"      : "close"

  initialize: ->
    @model.bind('change:description', this.render)
    @model.view = this

  render: =>
    $(@el).html( @template(@model.toJSON()) ).linkify()
    $(@el).toggleClass "completed", @model.get("completed")
    @input = @$(".edit")
    @input.autogrow({expandTolerance:0})
    return this

  togglecompleted: ->
    @model.toggle()
    @$el.toggleClass('completed')

  checkDirection: (e) ->
    if (e.distX > e.distY && e.distX < -e.distY) or (e.distX < e.distY && e.distX > -e.distY)
      e.preventDefault()
      return

  markIncompleted: ->
    @$el.removeClass('completed')
    @model.toggle() if @model.get("completed")

  markCompleted: ->
    @$el.addClass('completed')
    @model.toggle() if !@model.get("completed")

  edit: =>
    @$el.addClass("editing")
    @input.focus().val(@input.val())

  close: =>
    value = @input.val()
    @$el.removeClass("editing")
    if value
      @model.save({ description: value }) if value != @model.get('description')
    else 
      @clear()

  limitChars: (e) =>
    unless @input.val().length < $(e.target).attr('maxlength')
      e.preventDefault()

  updateOnEnter: (e) =>
    if e.which is 13
      e.preventDefault()
      e.stopPropagation()
      @close()

  clear: () ->
    @model.clear()
