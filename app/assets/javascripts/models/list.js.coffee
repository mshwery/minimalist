class listApp.Models.List extends Backbone.Model
  idAttribute: 'slug'

  initialize: ->
    @items ||= new listApp.Collections.Items()
    @items.list_id = @id
    @items.fetch({reset:true})

    @on 'change:slug', @updateParams

  updateParams: =>
    @items.list_id = @id

  clear: ->
    @view.remove()
    @destroy()
