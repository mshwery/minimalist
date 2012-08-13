class listApp.Routers.List extends Backbone.Router
  routes:
    '': 'show'

  show: ->
    listApp.log 'Routers: show'
    listApp.list = new listApp.Models.List(slug: listApp.Slug)
    listApp.view = new listApp.Views.ListsShow(model: listApp.list)
