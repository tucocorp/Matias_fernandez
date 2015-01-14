app.views.ConstraintFormModal = app.views.BaseModal.extend({
  title: function(){
    if( this.model.isNew() ){
      return 'Nueva restricción';
    }else{
      return 'Editar restricción';
    }
  },

  events: {
    'submit form': 'saveConstraint',
    'blur .new-constraint-submit-btn': 'hideErrors'
  },

  constraintBindings: {
    '.name': 'name',
    '.end-date': {
      observe: 'end_date',
      onGet: function(val){
        if( _.isUndefined(val) ){
          return null;
        }

        var date = moment(val).format('DD/MM/YYYY');
        this.$('.end-date').datepicker('setDate', date);
        return date;
      },

      onSet: function(val){
        var date = moment(val, 'DD/MM/YYYY').format('YYYY-MM-DD');
        return date;
      }
    },
    
    '.category-id': {
      observe: 'category_id',
      selectOptions: {
        collection: 'this.categories',
      },
      selectizeOptions: {
        labelField: 'name',
        valueField: 'id'
      }
    },

    '.assigned-id': {
      observe: 'assigned_id',
      selectOptions: {
        collection: 'this.members',
      },
      selectizeOptions:{
        labelField: 'full_name',
        valueField: 'id'
      }
    }
  },

  initialize: function(options){
    if( _.isUndefined(this.model) ){
      throw('Model must be specified attribute');
    }else if( _.isUndefined(options['activity']) ){
      throw('Activity options must be specified');
    }

    this.categories = options['categories'] || window.projectCategories;
    this.members    = options['members']    || window.projectMembers;
    this.activity   = options['activity'];
    this.reload     = options['reload'] || false;

    this.listenTo(this.model, 'invalid', this.showErrors);
  },

  yield: function(){
    return JST['constraint_form_modal']({
      activity: this.activity.toJSON()
    });
  },

  afterRender: function(){
    this.$('.end-date').datepicker({
      todayHighlight: true
    });

    this.$('input[type="text"]:first').focus();
    this.stickit(this.model, this.constraintBindings);
  },

  saveConstraint: function(e){
    e.preventDefault();
    $(e.currentTarget).popover('destroy');

    this.model.save({}, {
      success: _.bind(function(e){
        this.close();
        
        if( this.reload ){
          window.location.reload();
        }else{
          toastr.success('Se ha guardado la restricción exitosamente');
          this.model.trigger('saved', this.model);
        }
      }, this)
    });
  },

  showErrors: function(e){
    if(e.validationError.length > 0){
      var html = '<ul>';

      _.each(e.validationError, function(msg){
        html += '<li>'+ msg +'</li>'
      });

      html += '</ul>';

      this.$(".new-constraint-submit-btn").popover({
        html : true, 
        animation: false,
        container: 'body',
        content: html,
        trigger: 'manual',
        placement: 'top',
        title: 'No se puede guardar la fase'
      });

      this.$('.new-constraint-submit-btn').popover('show').focus();
    }
  },

  hideErrors: function(){
    this.$('.new-constraint-submit-btn').popover('destroy');
  }
});
