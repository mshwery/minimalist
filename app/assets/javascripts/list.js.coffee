# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
_.templateSettings = {
  interpolate: /\{\{\=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g
}

isMobile = -> 
  return Modernizr.touch

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
      #"movestart"       : "checkDirection"
      "move"            : "startMoveItem"
      "moveend"         : "stopMoveItem"
      #"swiperight"      : "markCompleted"
      "swipeleft"       : "markIncompleted"
      "click .toggle"   : "togglecompleted"
      "click .view"     : "edit"
      "click a.destroy" : "clear"
      "keypress .edit"  : "updateOnEnter"
      "blur .edit"      : "close"

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

    checkDirection: (e) ->
      if (e.distX > e.distY && e.distX < -e.distY) or (e.distX < e.distY && e.distX > -e.distY)
        e.preventDefault()
        return

    startMoveItem: (e) ->
      # Moves item with the finger
      dist = @includeDrag(e.distX)
      if dist > 0 && dist < @widthPercentage(38)
        $(@el).css('left', dist)

    widthPercentage: (num) ->
      return $(@el).outerWidth() * (num / 100)

    includeDrag: (distance) ->
      return drag = Math.round(distance / 2.25)

    stopMoveItem: (e) ->
      # stops moving item with the finger
      if @includeDrag(e.distX) > @widthPercentage(30)
        $(@el).animate({'left': ''}, 300)#.trigger('swiperight')
        @markCompleted()
      else
        $(@el).animate({'left': ''}, 300)

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

  class AppView extends Backbone.View
    el_tag = '#lists-app'
    el: $(el_tag)

    statsTemplate: _.template( $("#stats-template").html() )

    events:
      "keypress #new-item"  : "createOnEnter"
      "click #submit-new-item" : "createItem"
      "click #clear-completed": "clearCompleted"

    initialize: =>
      console.log 'initializing AppView'
      @input = this.$("#new-item")

      Items.bind("add", @addOne)
      Items.bind("reset", @addAll)
      Items.bind("all", @render)

      Items.fetch()

    render: =>
      this.$('#todo-stats').html(@statsTemplate({
        total:      Items.length,
        #done:       Items.completed().length,
        remaining:  Items.remaining().length
      }))

    addOne: (item) =>
      view = new ItemView({ model: item })
      this.$("#item-list").prepend( view.render().el )

    addAll: =>
      console.log 'adding items...'
      _.each(Items.remaining(), (item)=>
        @addOne(item)
      )

    newAttributes: ->
      return {
        description: @input.val()
        done:    false
      }

    createItem: ->
      Items.create( @newAttributes() )
      @input.val('')

    createOnEnter: (e) ->
      return if (e.keyCode != 13)
      @createItem()

    clearCompleted: ->
      _.each(Items.completed(), (item) ->
        item.clear()
      )
      return false

  Items = new ItemList
  App = new AppView()