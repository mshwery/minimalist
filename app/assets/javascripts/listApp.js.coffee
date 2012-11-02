$.extend listApp, 
  log: (msg) -> if console? then console.log(msg) else msg
  apiPrefix: (path='') -> "#{getPath(window.location.pathname)}/#{path}".replace('//','/')
  Models: {}
  Views: {}
  Collections: {}
  Routers: {}
  init: ->
    listApp.router = new listApp.Routers.List
    Backbone.history.start({pushState: true})
  isMobile: -> 
    return Modernizr.touch

getPath = (path) ->
  return path.split("/").slice(0, 4).join("/") 

$(document).ready ->
  listApp.init()
  $('#notifications').fadeIn().delay(3000).fadeOut()
