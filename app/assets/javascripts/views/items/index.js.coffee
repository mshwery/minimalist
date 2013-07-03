class listApp.Views.ItemsIndex extends Backbone.View
  el: '#item-list'

  initialize: ->
    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)

    @addAll()

    handler = if listApp.isMobile() then '.move' else false
    canceler = if listApp.isMobile() then '.view' else ':input,button'
    $(@el).sortable({ cursor: 'crosshair', axis: 'y', stop: @reorderCollection, handle: handler, cancel: canceler })

  addOne: (item) =>
    view = new listApp.Views.ItemsShow( model: item )
    $(@el).prepend( view.render().el )

  addAll: =>
    _.each(@collection.models, (item) => # remaining(), (item) =>
      @addOne(item)
    )

  reorderCollection: (e, ui) =>
    items = @collection.remaining() #({ description: $(ui.item).find('.view label').text() })
    $.each items, (i, v) =>
      v.reorder( v.view.$el.index() )

