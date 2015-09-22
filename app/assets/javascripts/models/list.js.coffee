class listApp.Models.List extends Backbone.Model
  initialize: ->
    @items ||= new listApp.Collections.Items()
    @items.list_id = @id
    @items.fetch({reset:true})

  clear: ->
    @view.remove()
    @destroy()
