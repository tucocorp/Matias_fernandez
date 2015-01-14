app.views.ActivityCard = Backbone.View.extend({

  events: {
    'click': 'open',
    'click .btn-close': 'close',
    'click .btn-edit': 'edit'
  },

  open: function(e){
    if( !this.$el.hasClass('open') ){
      if( !$(e.target).hasClass('btn-close') ){
        this.model
            .fetch()
            .done(_.bind(this.renderConstraints, this));
      }
    }
  },

  edit: function(e){
    e.preventDefault();

    var activityForm = new app.views.ActivityFormModal({
      model: this.model,
      members: window.projectMembers
    });

    activityForm.render();
    activityForm.open();
  },

  close: function(e){
    e.preventDefault();
    this.constraintsView.remove();
    this.$el.removeClass('open');
  },

  renderConstraints: function(){
    this.model.set('can_modify', this.model.canModify());
    this.$el.addClass('open');

    this.constraintsView = new app.views.ConstraintsCollectionView({
      model: this.model
    });

    this.$('.info').append(this.constraintsView.render().el);
  }
});
