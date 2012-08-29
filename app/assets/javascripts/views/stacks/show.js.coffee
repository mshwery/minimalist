class listApp.Views.StacksShow extends Backbone.View
  el: '#app'
  template: JST['stacks/show']

  events:
    "click .route" : "nav"
 
  initialize: ->
    listApp.log 'init stackView'
    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)

    @render()
    @collection.fetch()

  render: =>
    $(@el).prepend(@template(
      stack: @collection.models
      urlRoot: listApp.apiPrefix("lists")
    ))

  nav: (e) ->
    e.preventDefault()
    path = $(e.target).attr('href')
    listApp.router.navigate(path, {trigger: true}) if path

  addOne: (item) =>
    view = new listApp.Views.ListItemShow( model: item )
    $(@el).find('#my-lists .items').append( view.render().el )

  addAll: =>
    @collection.each((item) =>
      @addOne(item)
    )



class listApp.Views.ListItemShow extends Backbone.View
  tagName: "li"
  template: JST['lists/index']

  initialize: ->
    @model.on('change', @render)
    @model.items.on("all", @render)

  render: =>
    $(@el).html(@template(
      list: @model
      urlRoot: listApp.apiPrefix("lists")
    ))
    return this

