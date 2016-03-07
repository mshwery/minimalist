class listApp.Models.Contributor extends Backbone.Model  
  defaults: 
    image_url: '' 

  destroy: =>
    opts = {
      url: @collection.url(),
      contentType: 'application/json',
      data: JSON.stringify({
        email: @get('email')
      })
    }

    Backbone.Model.prototype.destroy.call(this, opts)
