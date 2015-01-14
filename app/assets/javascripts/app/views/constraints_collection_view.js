app.views.ConstraintsCollectionView = Backbone.View.extend({
  className: 'constraints-wrap',

  events: {
    'click .btn-uncompleted': 'uncompleteActivity',
    'click .btn-add-constraint': 'openNewConstraintModal',
    'click .edit-constraint': 'openEditConstraintModal',
    'click .constraint-item input': 'updateConstraintStatus'
  },

  initialize: function(){
    this.template = JST['constraints_collection'];

    this.collection = new app.collections.Constraints(
      this.model.get('constraints').map(function(attributes){
        return new app.models.Constraint(attributes);
      })
    );

    this.listenTo(this.collection, 'saved', function(data){
      this.render();
    });
  },

  render: function(){
    var data = this.data();

    this.$el.html(this.template( data ));
    return this;
  },

  data: function(){
    return {
      constraints: this.collection.toJSON(),
      activity: this.model.toJSON(),
      meta: this.model.meta,
      remaining_constraints: this.remainingConstraints()
    };
  },

  remainingConstraints: function(){
    var removed = this.collection.removedCount();
    var total   = this.collection.length;
    return removed + '/' + total;
  },

  uncompleteActivity: function(e){
    e.preventDefault();

    var noncomplianceFormModal = new app.views.NoncomplianceFormModal({
      activity: this.model,
      constraints: this.collection
    });

    noncomplianceFormModal.render();
    noncomplianceFormModal.open();
  },

  updateConstraintStatus: function(e){
    var $wrap = $(e.currentTarget).parents('li');
    var status = ($(e.currentTarget).is(':checked') == true) ? 'removed' : 'pending';
    var constraint_id = $wrap.attr('constraint-id');

    var constraint = this.collection.get(constraint_id);

    constraint
      .save({status: status})
      .done(_.bind(this.updatedConstraint, this));
  },

  updatedConstraint: function(constraint){
    var $wrap = this.$('ul li[constraint-id='+ constraint.id +']').first();

    if( constraint.status == 'removed' ){
      $wrap.addClass('removed');
    }else{
      $wrap.removeClass('removed');
    }

    var total = this.collection.length;
    var removed = this.collection.where({ status: 'removed' }).length;

    this.$el.parents('.info').find('.total').html(removed + '/' + total);

    $activity_wrap = this.$el.parents('.activity-wrap');

    if( (total - removed) == 0 ){
      $activity_wrap.find('.fa.fa-circle').addClass('pending');
    }else{
      $activity_wrap.find('.fa.fa-circle').removeClass('pending');
    }
  },

  openNewConstraintModal: function(e){
    e.preventDefault();

    var constraint = new app.models.Constraint({
      activity_id: this.model.get('id')
    });

    this.collection.add(constraint);

    var constraintFormModal = new app.views.ConstraintFormModal({
      activity: this.model,
      model: constraint
    });

    constraintFormModal.render();
    constraintFormModal.open();
  },

  openEditConstraintModal: function(e){
    e.preventDefault();
    var constraint = this.collection.get($(e.currentTarget).parents('li.constraint-item').attr('constraint-id'));

    var constraintFormModal = new app.views.ConstraintFormModal({
      activity: this.model,
      model: constraint
    }); 

    constraintFormModal.render();
    constraintFormModal.open();
  }
});
