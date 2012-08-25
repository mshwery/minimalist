window.demo = {
  "name": "Groceries",
  "id": 1,
  "slug": "demo",
  "demo": true
}

class listApp.Routers.List extends Backbone.Router
  routes:
    ''                : 'root'
    's/:token'        : 'index'
    's/:token/'       : 'index'
    's/:token/:slug'  : 'show'

  root: ->
    listApp.log 'root'
    listApp.demo = new listApp.Models.DemoList(window.demo) 
    listApp.view = new listApp.Views.ListsShow({ model: listApp.demo, el: '#app' })

    @setupDemo(listApp.view.$el)
    @toggleLoadScreen()

  index: (token) ->
    listApp.log token
    @toggleLoadScreen()

  new: ->
    listApp.log 'new'
    @toggleLoadScreen()

  show: (token, listSlug) ->
    listApp.log token + "/" + listSlug
    listApp.list = new listApp.Models.List(slug: listSlug)
    listApp.view = new listApp.Views.ListsShow(model: listApp.list)
    
    @toggleLoadScreen()

  toggleLoadScreen: ->
    $("#listapp").toggleClass('show hide')
    $("#listapp").siblings('#load-screen').toggleClass('show hide')

  setupDemo: ($view) ->
    $view.on('click', @addActiveClassToDemo)

  addActiveClassToDemo: (e) =>
    h = $(e.target).closest('#app').outerHeight()
    $(e.target).closest('#demo').addClass('active')
    @timer = setTimeout((=> @setMaxHeight()), 1000)

  setMaxHeight: ->
    $("#demo").addClass('complete')
