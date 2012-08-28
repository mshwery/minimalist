class listApp.Views.ItemsIndex extends Backbone.View
  el: '#item-list'

  initialize: ->
    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)

    @addAll()

  addOne: (item) =>
    view = new listApp.Views.ItemsShow( model: item )
    $(@el).prepend( $(view.render().el).hide().fadeIn() )

  addAll: =>
    _.each(@collection.remaining(), (item) =>
      @addOne(item)
    )
