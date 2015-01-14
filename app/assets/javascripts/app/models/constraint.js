app.models.Constraint = Backbone.Model.extend({
  urlRoot: '/constraints',

  validate: function(attrs, options){
    var errors = [];

    console.log(attrs);
    console.log( attrs.category_id );
    
    

    if( _.isEmpty(attrs.name) ){
      errors.push("Debe ingresar el título de la restricción");
    }

    if( !moment(attrs.end_date, 'YYYY-MM-DD').isValid() ){
      errors.push("Debe ingresar la fecha límite para remover la restricción");
    }

    if( attrs.category_id == undefined ||  attrs.category_id == ""){
      errors.push("Debe definir la categoría que pertenece la restricción");
    }

    return (errors.length == 0)? undefined : errors;
  }
});
