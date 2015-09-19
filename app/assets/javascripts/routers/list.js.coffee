window.demo = {
  "name": "Demo",
  "id": 1,
  "slug": "demo",
  "demo": true
}

class listApp.Routers.List extends Backbone.Router
  routes:
    ''                      : 'root'
    'preview'               : 'preview'
    's/:token'              : 'stack'
    's/:token/'             : 'stack'
    's/:token/lists'        : 'lists'
    's/:token/lists/new'    : 'new'
    's/:token/lists/:slug'  : 'list'

  initialize: ->
    @toggleLoadScreen()
    unless $('body').hasClass('pages-home') || $('body').hasClass('pages-preview')
      @setupSidebar()

  getDemoList: ->
    listApp.demo = new listApp.Models.DemoList(window.demo) 
    listApp.view = new listApp.Views.ListsShow({ model: listApp.demo })  

  preview: ->
    @getDemoList()

  root: ->
    @getDemoList()
    @setupDemo(listApp.view.$el)

  cleanupLists: ->
    if listApp.listView
      listApp.listView.remove()
      listApp.listView.unbind()

  stack: (token) ->
    @navigate('s/'+token+'/lists')

  lists: (token) ->      
    @cleanupLists()
    $("#sidebar").removeClass('list-is-selected')

  new: ->
    listApp.log 'new'

  list: (token, listIdOrSlug) ->
    @cleanupLists()

    if listApp.stack.get(listIdOrSlug)
      listApp.listView = new listApp.Views.ListsShow(model: listApp.stack.get(listIdOrSlug))
    else
      listApp.stack.on "reset", (collection, response) =>
        list = collection.get(listIdOrSlug) || collection.findWhere({ id: Number(listIdOrSlug) })
        if list then listApp.listView = new listApp.Views.ListsShow(model: list)

    $('#sidebar').addClass('list-is-selected')
    
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
