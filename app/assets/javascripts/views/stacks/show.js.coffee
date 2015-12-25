class listApp.Views.StacksShow extends Backbone.View
  el: '#app'
  template: JST['stacks/show']

  events:
    "click .remove-lists" : "removeLists"
    "click .add-list" : "newList",
    "click .sidebar-backdrop": "hideSidebar"

  initialize: ->
    @listenTo(@collection, 'add', @addOne)
    @listenTo(@collection, 'reset', @addAll)
    
    # suppresses 'add' events with {reset: true} and prevents the stack view
    # from being re-rendered for every model. only renders when the 'reset'
    # event is triggered at the end of the fetch 
    @collection.fetch({reset:true})

    # manually render because we only ever want one sidebar
    @render()

  render: =>
    $(@el).prepend(@template(
      user: window.user
      isUsersLists: location.pathname.indexOf('/dashboard') == 0
      stack: @collection.models
      urlRoot: listApp.appUrl("lists")
    ))

  hideSidebar: =>
    $('#sidebar').removeClass('shown') if $('body').hasClass('list-is-selected')

  addOne: (item) =>
    view = new listApp.Views.ListItemShow( model: item )
    $(@el).find('#my-lists .items').append( view.render().el )

  addAll: =>
    @collection.each((item) =>
      @addOne(item)
    )

  newList: (e) ->
    e.preventDefault()
    list = @collection.create({ name: 'Untitled List' }, { wait: true, success: (model, data) ->
      model.items.list_id = model.id
      path = listApp.appUrl('lists/' + model.id)
      listApp.router.navigate(path, {trigger: true})
    })

  removeLists: (e)->
    $stack = $(@el).find("#my-lists")
    $stack.toggleClass('editing')
    txt = if $stack.hasClass('editing') then 'Cancel' else 'Edit'
    $(e.target).text(txt)


# this is each item in the sidebar's list of lists
class listApp.Views.ListItemShow extends Backbone.View
  tagName: "li"
  className: "list-item"
  template: JST['lists/index']

  events:
    "click .delete-list" : "deleteList"
    "click .route" : "nav"

  initialize: ->
    @model.items.on("all", @render)
    @model.on("change", @render)
    @model.view = this

  render: =>
    $(@el).html(@template(
      list: @model
      urlRoot: listApp.appUrl("lists")
    ))
    return this

  nav: (e) ->
    e.preventDefault()
    $('#sidebar').removeClass('shown') if $('body').hasClass('list-is-selected')
    path = $(e.currentTarget).attr('href')
    listApp.router.navigate(path, {trigger: true}) if path

  deleteList: (e) ->
    e.stopPropagation()
    e.preventDefault()
    if confirm('Delete this list?')
      @model.clear()
      if listApp.listView.model.id == @model.id
        listApp.listView.remove()
        listApp.listView.unbind()
        listApp.router.navigate(listApp.appUrl('lists'), {trigger: true})

