app.collections.Constraints = Backbone.Collection.extend({
  model: app.models.Constraint,
  
  removed: function(){
    return this.filter(function(model){
      if( model.get('status') == 'removed' ){
        return model;
      }
    });
  },

  removedCount: function(){
    return this.removed.length;
  } 
});
