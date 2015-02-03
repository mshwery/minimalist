class listApp.Views.StacksShow extends Backbone.View
  el: '#app'
  template: JST['stacks/show']

  events:
    "click .remove-lists" : "removeLists"

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
      stack: @collection.models
      urlRoot: listApp.apiPrefix("lists")
    ))

  addOne: (item) =>
    view = new listApp.Views.ListItemShow( model: item )
    $(@el).find('#my-lists .items').append( view.render().el )

  addAll: =>
    @collection.each((item) =>
      @addOne(item)
    )

  removeLists: (e)->
    $stack = $(@el).find("#my-lists")
    $stack.toggleClass('editing')
    txt = if $stack.hasClass('editing') then 'Cancel' else 'Edit'
    $(e.target).text(txt)


# this is each item in the sidebar's list of lists
class listApp.Views.ListItemShow extends Backbone.View
  tagName: "li"
  className: "cf list-item"
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
      urlRoot: listApp.apiPrefix("lists")
    ))
    return this

  nav: (e) ->
    e.preventDefault()
    path = e.currentTarget.href
    listApp.router.navigate(path, {trigger: true}) if path

  deleteList: (e) ->
    e.stopPropagation()
    e.preventDefault()
    if confirm('Delete this list?')
      @model.clear()
      if listApp.listView.model.id == @model.id
        listApp.listView.remove()
        listApp.listView.unbind()
        listApp.router.navigate(listApp.apiPrefix('lists'), {trigger: true})

