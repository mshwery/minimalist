class listApp.Models.List extends Backbone.Model
  initialize: ->
    @items ||= new listApp.Collections.Items()
    @items.list_id = @id

    @contributors ||= new listApp.Collections.Contributors()
    @contributors.list_id = @id

    if !@isNew()
      @items.fetch({reset:true})

  getUsers: =>
    if listApp.apiPrefix().indexOf('/api') != -1
      @contributors.fetch({reset:true})

  clear: ->
    @view.remove()
    @destroy()
