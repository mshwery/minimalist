class listApp.Models.List extends Backbone.Model
  initialize: ->
    @items ||= new listApp.Collections.Items()
    @items.list_id = @id

    @users ||= new listApp.Collections.Users()
    @users.list_id = @id

    if !@isNew()
      @items.fetch({reset:true})

  getUsers: =>
    if listApp.apiPrefix().indexOf('/api') != -1
      @users.fetch({reset:true})

  clear: ->
    @view.remove()
    @destroy()
