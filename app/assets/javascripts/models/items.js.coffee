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
    console.log @get('sort_order') + " -> " + index 
    @save({ sort_order: index })

  clear: ->
    @view.$el.fadeOut(150, =>
      @view.remove()
    )
    @destroy()    



class listApp.Collections.Items extends Backbone.Collection
  model: listApp.Models.Item
  url: -> listApp.apiPrefix "lists/#{@list_id}/tasks"

  comparator: (item) ->
    return -item.get("sort_order")

  completed: ->
    return @filter (task) ->
      task.get "completed"

  remaining: ->
    return @without.apply( this, @completed() )

  nextOrder: ->
    @length + 1



class listApp.Collections.DemoItems extends Backbone.Collection
  model: listApp.Models.Item
  localStorage: new Backbone.LocalStorage("DemoItems")

  comparator: (item) ->
    return -item.get("sort_order")
    
  # comparator: (item) ->
  #   date = new Date(item.get('created_at'))
  #   return parseInt(date.getTime() / 1000)

  completed: ->
    return @filter (task) ->
      task.get "completed"

  remaining: ->
    return @without.apply( this, @completed() )
