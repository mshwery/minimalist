class listApp.Views.ItemsIndex extends Backbone.View
  el: '#item-list'

  initialize: ->
    listApp.log 'init items#index'
    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)
    #@collection.on("all", @render)

    @addAll()

  #render: =>

  addOne: (item) =>
    view = new listApp.Views.ItemsShow( model: item )
    $(@el).prepend( view.render().el )

  addAll: =>
    _.each(@collection.remaining(), (item) =>
      @addOne(item)
    )
