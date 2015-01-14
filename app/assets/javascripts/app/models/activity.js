app.models.Activity = Backbone.Model.extend({
  urlRoot: '/activities',

  defaults: {
    date_type: 'working'
  },

  initialize: function(){
    this.set('can_modify', this.canModify());
  },

  validate: function(attrs, options){
    var errors = [];

    if( _.isEmpty(attrs.name) ){
      errors.push(['activity-name', 'El nombre es requerido']);
    }

    return (errors.length == 0) ? undefined : errors;
  },

  parse: function(response){
    if( _.has(response, 'meta') ){
      this.meta = response['meta'];
    }

    if( _.has(response, 'activity') ){
      return response['activity'];
    }

    return response;
  },

  canModify: function(){
    var project_member = app.currentUser.get('project_member');

    if( _.contains(['owner', 'manager'], project_member.role) ){
      return true
    }

    return (parseInt(this.get('assigned_id')) === parseInt(project_member.id));
  }
});
