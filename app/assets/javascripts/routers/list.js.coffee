class listApp.Routers.List extends Backbone.Router
  routes:
    ''                : 'root'
    's/:token'        : 'index'
    's/:token/'       : 'index'
    's/:token/:slug'  : 'show'

  root: ->
    listApp.log 'root'
    listApp.list = new listApp.Models.List(slug: 'demo') 
    listApp.view = new listApp.Views.ListsShow({ model: listApp.list, el: '#app' })

    @toggleLoadScreen()

  index: (token) ->
    listApp.log token
    @toggleLoadScreen()

  show: (token, listSlug) ->
    listApp.log token + "/" + listSlug
    listApp.list = new listApp.Models.List(slug: listSlug)
    listApp.view = new listApp.Views.ListsShow(model: listApp.list)
    
    @toggleLoadScreen()

  toggleLoadScreen: ->
    $("#listapp").toggleClass('show hide')
    $("#listapp").siblings('#load-screen').toggleClass('show hide')
