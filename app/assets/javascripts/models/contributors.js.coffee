class listApp.Collections.Contributors extends Backbone.Collection
  model: listApp.Models.Contributor
  url: -> listApp.apiPrefix "lists/#{@list_id}/contributors"

  comparator: (a, b) ->
    aOwner = a.get('is_owner')
    bOwner = b.get('is_owner')

    if aOwner != bOwner
      return if aOwner < bOwner then 1 else -1
    else
      return if a.get('email') > b.get('email') then 1 else -1
