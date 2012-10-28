class listApp.Models.List extends Backbone.Model
  idAttribute: 'slug'

  initialize: ->
    @items ||= new listApp.Collections.Items()
    @items.list_id = @id
    @items.fetch()

    @on 'change:slug', @updateParams

  updateParams: =>
    @items.list_id = @id

  clear: ->
    @view.remove()
    @destroy()



class listApp.Collections.Lists extends Backbone.Collection
  model: listApp.Models.List
  url: -> listApp.apiPrefix()




window.demoItems = [
  {
    "completed":false,
    "created_at":"2012-07-24T05:07:54Z",
    "description":"Enter items & check them off",
    "id":1,
    "sort_order":1,
    "updated_at":"2012-07-26T02:55:40Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-23T05:07:53Z",
    "description":"Swipe right to check off on mobile (left to undo)",
    "id":2,
    "sort_order":2,
    "updated_at":"2012-07-26T02:55:40Z"
  },  
  {
    "completed":false,
    "created_at":"2012-07-22T05:07:53Z",
    "description":"Double-click to edit items",
    "id":3,
    "sort_order":3,
    "updated_at":"2012-07-26T02:55:40Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-21T02:47:14Z",
    "description":"Click the trashcan or clear text to delete an item",
    "id":4,
    "sort_order":4,
    "updated_at":"2012-07-26T02:55:38Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-21T02:47:14Z",
    "description":"Drag and drop items to reorder your list",
    "id":5,
    "sort_order":5,
    "updated_at":"2012-07-26T02:55:38Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-21T02:47:14Z",
    "description":"Refresh your list to get rid of completed items (or to see any additions if you're sharing your list)",
    "id":6,
    "sort_order":6,
    "updated_at":"2012-07-26T02:55:38Z"
  }
]


class listApp.Models.DemoList extends Backbone.Model
  url: '/demo.json'
  idAttribute: 'slug'

  initialize: ->
    listApp.log 'init demo'

    @items ||= new listApp.Collections.DemoItems(window.demoItems)
