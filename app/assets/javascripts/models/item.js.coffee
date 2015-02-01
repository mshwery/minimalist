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
