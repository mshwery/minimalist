class listApp.Models.Item extends Backbone.Model
  defaults: 
    description: "empty item..."
    completed: false

  initialize: ->
    if !@get("description")
      @set({ "description": @defaults.description })

    # dont bind directly to @save because a second change event will fire
    # since the change:sort_order would pass the changed attributes to the save
    @bind("change:sort_order", @saveOrder)

  toggle: ->
    @save({ completed: !@get("completed") })

  saveOrder: () ->
    @save()

  clear: ->
    @view.remove()
    @destroy()  
