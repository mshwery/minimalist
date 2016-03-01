class listApp.Collections.Contributors extends Backbone.Collection
  model: listApp.Models.Contributor
  url: -> listApp.apiPrefix "lists/#{@list_id}/contributors"

