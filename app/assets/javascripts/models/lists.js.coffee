class listApp.Models.List extends Backbone.Model
  urlRoot: listApp.apiUrl ''
  idAttribute: 'slug'

  initialize: ->
    listApp.log 'init list'
    @items ||= new listApp.Collections.Items()
    @items.list_id = @id
    @items.fetch()
