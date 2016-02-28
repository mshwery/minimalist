# this is the actual selected list view
class listApp.Views.ListsShow extends Backbone.View
  className: "selected-list"
  template: JST['lists/show']

  events: 
    "dblclick #stats h2"  : "edit"
    "doubletap #stats h2" : "edit"   
    "keypress #stats .edit"      : "updateOnEnter"
    "blur #stats .edit"          : "close"
    "click .refresh"      : "refresh"
    "click .back"         : "showSidebar"

  initialize: ->
    @model.on('change:name', @updateName)
    @longPoll(true)
    @render()
    @hideSidebar()

  render: =>
    $(@el).html(@template(
      user: window.user
      url: @model.urlRoot
      name: @model.get('name')
      remaining: @model.items.remaining().length
    ))

    @app = if @model.get('demo') then '#demo' else '#app'
    $(@app).append $(@el)

    @input = @$("#stats .edit")

    @initItems()
    @renderNewItemForm()
    return this

  remove: () ->
    # disable long polling
    @longPoll(false)
    @model.unbind('change:name', @updateName)
    super()

  showSidebar: (e) ->
    e.preventDefault() unless !e
    $('#sidebar').addClass('shown')

  hideSidebar: (e) ->
    e.preventDefault() unless !e
    $('#sidebar').removeClass('shown')

  longPoll: (longpoll) =>
    # set @pollingEnabled if an argument was passed in
    if typeof longpoll == 'boolean'
      @pollingEnabled = longpoll

    # clear the timeout (if there is one)
    if @longpoll
      clearTimeout(@longpoll)

    # fetch the model, and recursively call this fn
    if @pollingEnabled && !@model.isNew()
      @model.items.fetch({
        add: false,
        remove: false,
        merge: false,
        success: @getChanges
      })
      @longpoll = setTimeout(@longPoll, 15 * 1000)

  updateName: =>
    @$('#stats h2').text(@model.get('name'))

  edit: =>
    @$("#stats").addClass("editing")
    @input.focus().val(@input.val()).select()

  close: =>
    value = @input.val()
    if value && value != @model.get('name')
      if @model.get('demo')
        @model.set({name: value})
      else
        @model.save({name: value}, {success: @setUrl})
    @$('#stats').removeClass("editing")

  setUrl: =>
    path = window.location.pathname.split("/").slice(0, -1).join("/")
    newPath = [path, @model.get('id')].join("/")
    listApp.router.navigate(newPath)

  updateOnEnter: (e) =>
    if e.which is 13
      e.preventDefault()
      e.stopPropagation()
      @close()

  initItems: =>
    @itemView ||= new listApp.Views.ItemsIndex( collection: @model.items )

  renderNewItemForm: =>
    @newItemView ||= new listApp.Views.ItemsNew( collection: @model.items )

  refresh: ->
    @$el.addClass('loading')

    # then fetch/sync with the server, there could be remote changes
    # use `reset: true` so that new sort order is manifested
    @model.items.fetch
      reset: true
      wait: true
      success: => @afterRefresh()

  afterRefresh: ->
    setTimeout((=> @$el.removeClass('loading')), 300)
    @removeNotification()

  getChanges: (collection, response) =>    
    responseIds = _.pluck(response, 'id')
    collectionIds = _.pluck(collection.toJSON(), 'id')

    sameIds = _.intersection(responseIds, collectionIds)
    addedIds = _.difference(responseIds, collectionIds)
    removedIds = _.difference(collectionIds, responseIds)

    # get the new models
    @modelsToAdd = _.filter(response, (item) ->
      return addedIds.indexOf(item.id) != -1
    )

    @modelsToRemove = _.filter(collection.toJSON(), (item) ->
      return removedIds.indexOf(item.id) != -1
    )

    # get list of same objects that have some change
    @modelsToMerge = _.filter(collection.toJSON(), (item) =>
      a = @pickMainAttrs(item)
      b = @pickMainAttrs(_.find(response, { id: item.id }))
      return !_.isEqual(a, b) && removedIds.indexOf(item.id) == -1
    )

    changesCount = @modelsToAdd.concat(@modelsToRemove, @modelsToMerge).length

    if (changesCount)
      @notifyNewItems(changesCount)

  pickMainAttrs: (model) ->
    return _.pick(model, ['id', 'description', 'completed'])

  notifyNewItems: (count) ->
    @$el.find('.changes-count').text(count).addClass('show')

  removeNotification: ->
    @$el.find('.changes-count').removeClass('show')
