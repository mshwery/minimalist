class listApp.Views.ItemsShow extends Backbone.View
  tagName: "li"
  className: 'cf todo'

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
    @model.bind('change:description', @render)
    @model.bind('change:completed', @renderCompleted)
    @model.bind('remove', @removeEl)
    @model.view = this

  render: =>
    $(@el).html( @template(@model.toJSON()) ).linkify()
    @renderCompleted()
    @input = @$(".edit")
    @input.autogrow({expandTolerance:0})
    return this

  removeEl: =>
    @model.view.remove()

  renderCompleted: =>
    @$el.toggleClass('completed', @model.get('completed'))

  togglecompleted: ->
    if !@$el.hasClass('editing')
      @model.toggle()
      @renderCompleted()

  checkDirection: (e) ->
    if (e.distX > e.distY && e.distX < -e.distY) or (e.distX < e.distY && e.distX > -e.distY)
      e.preventDefault()
      return

  markIncompleted: ->
    @model.toggle() if @model.get("completed")
    @renderCompleted()

  markCompleted: ->
    @model.toggle() if !@model.get("completed")
    @renderCompleted()

  edit: =>
    @$el.addClass("editing")
    @input.focus().val(@input.val())

  close: =>
    value = @input.val()
    @$el.removeClass("editing")
    if value
      @model.save({ description: value }) if value != @model.get('description')
    else
      @model.clear()

  limitChars: (e) =>
    unless @input.val().length < $(e.target).attr('maxlength')
      e.preventDefault()

  updateOnEnter: (e) =>
    if e.keyCode is 13
      e.preventDefault()
      e.stopPropagation()
      @close()

  clear: =>
    @model.clear()
