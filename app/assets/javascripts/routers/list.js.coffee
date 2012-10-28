window.demo = {
  "name": "Demo",
  "id": 1,
  "slug": "demo",
  "demo": true
}

class listApp.Routers.List extends Backbone.Router
  routes:
    ''                      : 'root'
    's/:token/lists'        : 'lists'
    'a/:token/lists'        : 'lists'
    's/:token/lists/:slug'  : 'list'
    'a/:token/lists/:slug'  : 'list'

  initialize: ->
    @toggleLoadScreen()
    unless $('body').hasClass('pages-home') && !window.currentUser
      @setupSidebar()

  root: ->
    if window.currentUser
      @navigate('lists', {trigger: true})
    else
      listApp.demo = new listApp.Models.DemoList(window.demo) 
      listApp.view = new listApp.Views.ListsShow({ model: listApp.demo })
      @setupDemo(listApp.view.$el)

  lists: ->
    if listApp.listView
      listApp.listView.remove()
      listApp.listView.unbind()
      
    $("#sidebar").removeClass('desktop-only')

  list: (token, listSlug) ->
    listApp.log 'list'
    if listApp.listView
      listApp.listView.remove()
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
    listApp.log listApp.apiPrefix()
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
