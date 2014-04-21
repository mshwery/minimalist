$.extend listApp, 
  log: (msg) -> if console? then console.log(msg) else msg
  apiPrefix: (path) -> "#{getStackPath(window.location.pathname)}/#{path}"
  Models: {}
  Views: {}
  Collections: {}
  Routers: {}
  init: ->
    listApp.router = new listApp.Routers.List
    Backbone.history.start({pushState: true, root: "/"})
  isMobile: -> 
    return Modernizr.touch

getStackPath = (path) ->
  # returns /s/<stackUrl> and drops everything after
  return path.split("/").slice(0, 3).join("/")

# this ensures that the browser back button doesn't render json accidentally
# because some browsers will resuse cached ajax requests
$.ajaxSetup({ cache: false })

$(document).ready ->
  listApp.init()
