class listApp.Models.List extends Backbone.Model
  initialize: ->
    @items ||= new listApp.Collections.Items()
    @contributors ||= new listApp.Collections.Contributors()
    @setListId()

    # listen to sync event on model
    @bind('sync', @setListId)

    if !@isNew()
      @items.fetch({reset:true})
      @getUsers()

  setListId: =>
    @items.list_id = @id
    @contributors.list_id = @id

  getUsers: =>
    if @get('is_owner') && listApp.apiPrefix().indexOf('/api') != -1
      @contributors.fetch({reset:true})

  leave: =>
    opts = {
      url: @collection.url() + '/' + @get('id') + '/leave',
      contentType: 'application/json'
    }

    Backbone.Model.prototype.destroy.call(this, opts)
