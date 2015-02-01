class listApp.Models.Item extends Backbone.Model
  defaults: 
    description: "empty item..."
    completed: false

  initialize: ->
    if !@get("description")
      @set({ "description": @defaults.description })

  toggle: ->
    @save({ completed: !@get("completed") })

  reorder: (index) ->
    @save({ sort_order: index })

  clear: ->
    @view.remove()
    @destroy()  



class listApp.Collections.Items extends Backbone.Collection
  model: listApp.Models.Item
  url: -> listApp.apiPrefix "lists/#{@list_id}/tasks"

  comparator: "sort_order"

  completed: ->
    return @filter (task) ->
      task.get "completed"

  remaining: ->
    return @without.apply( this, @completed() )

  nextOrder: ->
    @length + 1



class listApp.Collections.DemoItems extends listApp.Collections.Items
  localStorage: new Backbone.LocalStorage("DemoItems")
