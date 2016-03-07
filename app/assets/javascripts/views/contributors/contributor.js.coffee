class listApp.Views.Contributor extends Backbone.View
  tagName: 'li'
  className: 'list-contributor'
  template: JST['contributors/contributor']

  events:
    "click .remove-contributor" : "removeContributor"

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this

  removeContributor: =>
    @model.destroy()
