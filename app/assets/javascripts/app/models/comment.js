app.models.Comment = Backbone.Model.extend({
  urlRoot: '/comments',

  validate: function(attrs, options){
    var errors = [];

    if( _.isEmpty(attrs.content) ){
      errors.push('Debe ingresar un comentario');
    }

    return (errors.length == 0) ? undefined : errors;
  }
});
