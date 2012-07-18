# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
}


$ ->
  console.log 'ready...'

  console.log "looking up list: " + window.location.pathname

  ## task model
  class Item extends Backbone.Model
    defaults: 
      description: "empty item..."
      completed: false

    initialize: ->
      console.log 'initializing Item'
      if !@get("description")
        @set({ "description": @defaults.description })

    toggle: ->
      @save({ completed: !@get("completed") })

    clear: ->
      @destroy()
      @view.remove()


  ## collection of tasks
  class ItemList extends Backbone.Collection
    model: Item
    url: window.location.pathname + '/tasks'

    completed: ->
      return @filter (task) ->
        task.get "completed"

    remaining: ->
      return @without.apply( this, @completed() )


  ## setup the task item view
  class ItemView extends Backbone.View
    tagName: "li"
    className: 'cf'

    template: _.template( $("#item-template").html() )

    events:
      "click .toggle": "togglecompleted"
      "click .view": "edit"
      "click a.destroy": "clear"
      "keypress .edit": "updateOnEnter"
      "blur .edit": "close"

    initialize: ->
      @model.bind('change', this.render)
      @model.view = this

    render: =>
      $(@el).html( @template(@model.toJSON()) )
      $(@el).toggleClass "completed", @model.get("completed")
      @input = @$(".edit")
      return this

    togglecompleted: ->
      @model.toggle()

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

  class AppView extends Backbone.View
    el_tag = '#lists-app'
    el: $(el_tag)

    events:
      "keypress #new-item"  : "createOnEnter"

    initialize: =>
      console.log 'initializing AppView'
      @input = this.$("#new-item")

      Items.bind("add", @addOne)
      Items.bind("reset", @addAll)
      Items.bind("all", @render)

      Items.fetch()

    addOne: (item) =>
      view = new ItemView({ model: item })
      this.$("#item-list").append( view.render().el )

    addAll: =>
      console.log 'adding items...'
      Items.each( @addOne )

    newAttributes: ->
      return {
        description: @input.val()
        done:    false
      }

    createOnEnter: (e) ->
      return if (e.keyCode != 13)
      Items.create( @newAttributes() )
      @input.val('')

  Items = new ItemList
  App = new AppView()