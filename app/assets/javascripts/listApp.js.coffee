$.extend listApp, 
  log: (msg) -> if console? then console.log(msg) else msg
  apiUrl: (path) -> "#{getParentPath(window.location.pathname)}/#{path}"
  Models: {}
  Views: {}
  Collections: {}
  Routers: {}
  init: ->
    new listApp.Routers.List
    Backbone.history.start()
  isMobile: -> 
    return Modernizr.touch

getParentPath = (path) ->
  return path.split("/").slice(0, -1).join("/")

$(document).ready ->
  if $('body').hasClass('lists-show')
    listApp.init()
