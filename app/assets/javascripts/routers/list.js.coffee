window.demo = {
  "name": "Demo",
  "id": 1,
  "demo": true
}

class listApp.Routers.List extends Backbone.Router
  routes:
    '(/)'                    : 'root'
    'preview(/)'             : 'preview'
    'dashboard(/)'           : 'lists'
    'dashboard/lists(/)'     : 'lists'
    'dashboard/lists/:id(/)' : 'getList'
    's/:token(/)'            : 'stack'
    's/:token/lists(/)'      : 'lists'
    's/:token/lists/:id(/)'  : 'list'

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
    $('body').removeClass('list-is-selected')
    $('#sidebar').addClass('shown')

  list: (token, listId) ->
    @getList(listId)
  
  getList: (listId) ->
    @cleanupLists()

    if listApp.lists.get(listId)
      $('body').addClass('list-is-selected')
      listApp.listView = new listApp.Views.ListsShow(model: listApp.lists.get(listId))
    else
      listApp.lists.on "reset", (collection, response) =>
        list = collection.get(listId)
        if list
          $('body').addClass('list-is-selected')
          listApp.listView = new listApp.Views.ListsShow(model: list)
        else
          @navigate(listApp.appUrl('lists'), {trigger: true})

  toggleLoadScreen: ->
    $("#app").toggleClass('show hide')
    $("#app").siblings('#load-screen').toggleClass('show hide')

    unless listApp.isMobile()
      $("#app").addClass("desktop")

  setupSidebar: ->
    listApp.lists ||= new listApp.Collections.Lists()
    listApp.listsView = new listApp.Views.StacksShow(collection: listApp.lists)

  setupDemo: ($view) ->
    $view.on('click', @addActiveClassToDemo)

  addActiveClassToDemo: (e) =>
    h = $(e.target).closest('#demo').outerHeight()
    $(e.target).closest('#demo').addClass('active')
    @timer = setTimeout((=> @setMaxHeight()), 1000)

  setMaxHeight: ->
    $("#demo").addClass('complete')
