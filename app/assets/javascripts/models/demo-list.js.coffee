window.demoItems = [
  {
    "completed":false,
    "created_at":"2012-07-24T05:07:54Z",
    "description":"Supports touch gestures (swipe right/left)",
    "id":1,
    "sort_order":1,
    "updated_at":"2012-07-26T02:55:40Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-23T05:07:53Z",
    "description":"Double-tap to edit",
    "id":2,
    "sort_order":2,
    "updated_at":"2012-07-26T02:55:40Z"
  },  
  {
    "completed":false,
    "created_at":"2012-07-22T05:07:53Z",
    "description":"Drag 'n drop to reorder your list",
    "id":3,
    "sort_order":3,
    "updated_at":"2012-07-26T02:55:40Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-21T02:47:14Z",
    "description":"Manage one-to-many lists at a time",
    "id":4,
    "sort_order":4,
    "updated_at":"2012-07-26T02:55:38Z"
  },
  {
    "completed":false,
    "created_at":"2012-07-21T02:47:14Z",
    "description":"Resync to clear out the old",
    "id":6,
    "sort_order":6,
    "updated_at":"2012-07-26T02:55:38Z"
  }
]


class listApp.Models.DemoList extends Backbone.Model
  url: '/demo.json'
  idAttribute: 'id'

  initialize: ->
    listApp.log 'init demo'

    @items ||= new listApp.Collections.DemoItems(window.demoItems)
