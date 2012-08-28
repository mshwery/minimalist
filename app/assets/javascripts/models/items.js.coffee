class listApp.Models.Item extends Backbone.Model
  defaults: 
    description: "empty item..."
    completed: false

  initialize: ->
    if !@get("description")
      @set({ "description": @defaults.description })

  toggle: ->
    @save({ completed: !@get("completed") })

  clear: ->
    @view.$el.fadeOut(300, =>
      @view.remove()
    )
    #@view.remove()  
    @destroy()    



class listApp.Collections.Items extends Backbone.Collection
  model: listApp.Models.Item
  url: -> listApp.apiUrl "#{@list_id}/tasks"

  comparator: (item) ->
    date = new Date(item.get('created_at'))
    return parseInt(date.getTime() / 1000)

  completed: ->
    return @filter (task) ->
      task.get "completed"

  remaining: ->
    return @without.apply( this, @completed() )



class listApp.Collections.DemoItems extends Backbone.Collection
  model: listApp.Models.Item
  localStorage: new Backbone.LocalStorage("DemoItems")

  comparator: (item) ->
    date = new Date(item.get('created_at'))
    return parseInt(date.getTime() / 1000)

  completed: ->
    return @filter (task) ->
      task.get "completed"

  remaining: ->
    return @without.apply( this, @completed() )
