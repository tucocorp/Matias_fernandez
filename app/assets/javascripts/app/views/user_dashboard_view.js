app.views.UserDashboardView = Backbone.View.extend({

  events: {
    'click .edit-constraint-btn': 'editConstraint',
    'click .destroy-constraint-btn': 'destroyConstraint',
    'click .new-project-btn': 'openNewProjectFormModal',
    'click .constraints-list .item input': 'removeConstraint'
  },

  openNewProjectFormModal: function(e){
    e.preventDefault();

    var projectModal = new app.views.NewProjectModal();
    projectModal.render();
    projectModal.open();
  },

  editConstraint: function(e){
    e.preventDefault();
    var constraint_id = $(e.currentTarget).attr('constraint-id');
    var self = this;

    var constraint = new app.models.Constraint({
      id: constraint_id
    });

    constraint
      .fetch()
      .success(function(data){
        var activity = new app.models.Activity(constraint.get('activity'));
        var members     = constraint.get('project_members');
        var categories  = constraint.get('project_categories');

        self.openConstraintFormModal(constraint, activity, members, categories);
      });
  },

  openConstraintFormModal: function(constraint, activity, members, categories){
    var constrainFormModal = new app.views.ConstraintFormModal({
      model: constraint,
      activity: activity,
      members: members,
      categories: categories,
      reload: true
    });

    constrainFormModal.render();
    constrainFormModal.open();
  },

  removeConstraint: function(e){
    var $label = $(e.currentTarget);
    var status = ($(e.currentTarget).is(':checked') == true) ? 'removed' : 'pending';
    var constraint_id = $(e.currentTarget).attr('constraint-id');
    var constraint = new app.models.Constraint({ id: constraint_id });

    constraint
      .save({ status: status })
      .success(function(){
        $label.parents('label').toggleClass('removed');
      });
  },

  destroyConstraint: function(e){
    e.preventDefault();

    if( confirm('¿Estás seguro que deseas eliminar esta restricción?') ){
      var constraint_id = $(e.currentTarget).attr('constraint-id');
      var constraint = new app.models.Constraint({ id: constraint_id });

      constraint
        .destroy()
        .success(function(){
          window.location.reload();
        });
    }
  }
});
