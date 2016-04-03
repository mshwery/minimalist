class listApp.Views.ItemsIndex extends Backbone.View
  el: '#item-list'

  initialize: ->
    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)

    @addAll()

    handler = '.move'
    canceler = if listApp.isMobile() then '.view' else ':input,button'
    $(@el).sortable({ cursor: 'move', containment: 'body', stop: @reorderCollection, handle: handler, cancel: canceler })

  addOne: (item) =>
    view = new listApp.Views.ItemsShow( model: item )
    $(@el).append( view.render().el )

  addAll: =>
    # ensure the list is empty before inserting the entire new list
    $(@el).empty()

    # only render remaining todos on reset
    _.each @collection.remaining(), (item) =>
      @addOne(item)

  reorderCollection: (e, ui) =>
    _.each @collection.remaining(), (item) =>
      item.set({ sort_order: item.view.$el.index() })
