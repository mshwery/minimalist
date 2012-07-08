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
  class Task extends Backbone.Model
    defaults: 
      description: "empty task..."
      completed: false

    initialize: ->
      console.log 'initializing Task'
      if !@get("description")
        @set({ "description": @defaults.description })

    toggle: ->
      @save({ completed: !@get("completed") })

    clear: ->
      @destroy()


  ## collection of tasks
  class TaskList extends Backbone.Collection
    model: Task
    url: window.location.pathname + 'tasks'

    completed: ->
      return @filter (task) ->
        task.get "completed"

    remaining: ->
      return @without.apply( this, @completed() )


  ## setup the task item view
  class TaskView extends Backbone.View
    tagName: "li"

    template: _.template( $("#task-template").html() )

    events:
      "click .toggle": "togglecompleted"
      "dblclick .view": "edit"
      "click a.destroy": "clear"
      "keypress .edit": "updateOnEnter"
      "blur .edit": "close"

    initialize: ->
      @model.bind('change', this.render)
      @model.view = this
      #@model.bind('destroy', this.remove)

    render: =>
      $(@el).html( @template(@model.toJSON()) )
      $(@el).toggleClass "completed", @model.get("completed")
      @input = @$(".edit")
      return this

    togglecompleted: ->
      @model.toggle()

    edit: =>
      $(@el).addClass("editing")
      @input.focus()

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

    initialize: =>
      console.log 'initializing TaskListView'
      Tasks.bind("add", @addOne)
      Tasks.bind("reset", @addAll)
      Tasks.bind("all", @render)

      Tasks.fetch()
      console.log "fetched..."

    addOne: (task) =>
      view = new TaskView({ model: task })
      this.$("#todo-list").append( view.render().el )

    addAll: =>
      console.log 'adding tasks...'
      Tasks.each( @addOne )

  Tasks = new TaskList
  App = new AppView()