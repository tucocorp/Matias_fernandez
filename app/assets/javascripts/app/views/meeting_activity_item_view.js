app.views.MeetingActivityItemView = Backbone.View.extend({
  className: 'activity-item',

  events: {
    'click .show-description-btn': 'showDescription',
    'click .hide-description-btn': 'hideDescription',
    'click .edit-btn': 'editActivity',
    'click .destroy-btn': 'destroyActivity'
  },

  initialize: function(options){
    this.template = JST['meeting_activity_item'];

    this.listenTo(this.model, 'remove', this.animateExit);
    this.listenTo(this.model, 'saved', this.updateActivity);
  },

  render: function(){
    this.$el.html(this.template({
      activity: this.model.toJSON()
    }));

    this.$('.assigned').tooltip();

    return this;
  },

  animateEntrance: function(){
    this.$el.css({ display: 'none', background: '#FFFDE1' });

    this.$el.slideDown(100).delay(300).animate({
      "backgroundColor": "transparent"
    }, 50, function(a){
      $(this).css('background', '');
    });
  },

  animateExit: function(){
    this.$el.css({ background: '#FFFDE1' });

    this.$el.slideUp(100).delay(300).animate({
      "backgroundColor": "transparent"
    }, 50, function(a){
      this.remove();
    });
  },

  showDescription: function(e){
    e.preventDefault();
    this.$('.description').removeClass('hidden');
    this.$('.show-description-btn').addClass('hidden');
    this.$('.hide-description-btn').removeClass('hidden');
  },

  hideDescription: function(e){
    e.preventDefault();
    this.$('.description').addClass('hidden');
    this.$('.hide-description-btn').addClass('hidden');
    this.$('.show-description-btn').removeClass('hidden');
  },

  editActivity: function(e){
    e.preventDefault();

    var modal = new app.views.ActivityFormModal({
      model: this.model,
      members: window.members,
      reload: false
    });

    modal.render();
    modal.open();
  },

  updateActivity: function(e){
    this.render();
    this.animateEntrance();
  },

  destroyActivity: function(e){
    e.preventDefault();
    this.model.destroy();
  }
});
