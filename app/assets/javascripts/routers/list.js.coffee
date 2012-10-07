window.demo = {
  "name": "Demo",
  "id": 1,
  "slug": "demo",
  "demo": true
}

class listApp.Routers.List extends Backbone.Router
  routes:
    ''                : 'root'
    's/:token'        : 'stack'
    's/:token/'       : 'stack'
    's/:token/lists'  : 'lists'
    's/:token/lists/new'    : 'new'
    's/:token/lists/:slug'  : 'list'

  initialize: ->
    @toggleLoadScreen()
    unless $('body').hasClass('pages-home')
      @setupSidebar()

  root: ->
    listApp.demo = new listApp.Models.DemoList(window.demo) 
    listApp.view = new listApp.Views.ListsShow({ model: listApp.demo, el: '#demo' })

    @setupDemo(listApp.view.$el)

  stack: (token) ->
    @navigate('s/'+token+'/lists')

  lists: (token) ->
    $("#list").remove()
    listApp.listView.unbind() if listApp.listView
    $("#sidebar").removeClass('desktop-only')

  new: ->
    listApp.log 'new'

  list: (token, listSlug) ->
    if listApp.listView
      listApp.log 'remove view'
      $("#list").remove()
      listApp.listView.unbind()

    if listApp.stack.get(listSlug)
     listApp.listView = new listApp.Views.ListsShow(model: listApp.stack.get(listSlug))
    else
      listApp.stack.on "reset", (collection, response) =>
        list = collection.get(listSlug)
        listApp.listView = new listApp.Views.ListsShow(model: list)

    if listApp.isMobile()
      $('#sidebar').addClass('desktop-only')
    
  toggleLoadScreen: ->
    $("#app").toggleClass('show hide')
    $("#app").siblings('#load-screen').toggleClass('show hide')

    unless listApp.isMobile()
      $("#app").addClass("desktop")

  setupSidebar: ->
    listApp.stack ||= new listApp.Collections.Lists()
    listApp.stackView = new listApp.Views.StacksShow(collection: listApp.stack)

  setupDemo: ($view) ->
    $view.on('click', @addActiveClassToDemo)

  addActiveClassToDemo: (e) =>
    h = $(e.target).closest('#demo').outerHeight()
    $(e.target).closest('#demo').addClass('active')
    @timer = setTimeout((=> @setMaxHeight()), 1000)

  setMaxHeight: ->
    $("#demo").addClass('complete')
