app.models.User = Backbone.Model.extend({
  urlRoot: '/users',

  parse: function(response){
    if( _.has(response, 'meta') ){
      this.meta = response['meta'];
    }

    if( _.has(response, 'user') ){
      return response['user'];
    }

    return response;
  }
});