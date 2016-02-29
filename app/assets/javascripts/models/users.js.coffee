class listApp.Collections.Users extends Backbone.Collection
  model: listApp.Models.User
  url: -> listApp.apiPrefix "lists/#{@list_id}/users"

