class listApp.Views.ItemsIndex extends Backbone.View
  
  el: '#item-list'

  initialize: ->
    # @listenTo(@collection, 'add', @addOne)
    # @listenTo(@collection, 'reset', @addAll)
    # @listenTo(@collection, 'all', @render)
    
    # # suppresses 'add' events with {reset: true} and prevents the stack view
    # # from being re-rendered for every model. only renders when the 'reset'
    # # event is triggered at the end of the fetch 
    # @collection.fetch({reset: true})

    @collection.on("add", @addOne)
    @collection.on("reset", @addAll)

    @addAll()

    handler = if listApp.isMobile() then '.move' else false
    canceler = if listApp.isMobile() then '.view' else ':input,button'
    $(@el).sortable({ cursor: 'crosshair', axis: 'y', stop: @reorderCollection, handle: handler, cancel: canceler })

  addOne: (item) =>
    view = new listApp.Views.ItemsShow( model: item )
    $(@el).append( view.render().el )

  addAll: =>
    $(@el).empty()
    # only render remaining todos on reset
    _.each(@collection.remaining(), (item) =>
      @addOne(item)
    )

  reorderCollection: (e, ui) =>
    items = @collection.remaining()
    $.each items, (i, v) =>
      v.reorder( v.view.$el.index() )

