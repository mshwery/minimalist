class listApp.Collections.Lists extends Backbone.Collection
  model: listApp.Models.List
  url: -> listApp.apiPrefix "lists"
