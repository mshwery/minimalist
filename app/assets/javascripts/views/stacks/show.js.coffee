class listApp.Views.StacksShow extends Backbone.View
  el: '#app'
  template: JST['stacks/show']

  events:
    "click .remove-lists" : "removeLists"

  initialize: ->
    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)

    @render()
    @collection.fetch()

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



class listApp.Views.ListItemShow extends Backbone.View
  tagName: "li"
  className: "cf list-item"
  template: JST['lists/index']

  events:
    "click .delete" : "removeList"
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
    path = $(e.target).attr('href')
    listApp.router.navigate(path, {trigger: true}) if path

  removeList: (e) ->
    e.stopPropagation()
    e.preventDefault()
    if confirm('Delete this list?')
      @model.clear()
      if listApp.listView.model.id == @model.id
        listApp.listView.remove()
        listApp.listView.unbind()
        listApp.router.navigate(listApp.apiPrefix('lists'), {trigger: true})

