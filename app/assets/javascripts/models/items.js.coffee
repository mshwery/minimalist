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
