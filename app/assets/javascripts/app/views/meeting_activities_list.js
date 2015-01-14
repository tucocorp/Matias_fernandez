app.views.MeetingActivitiesList = Backbone.View.extend({
  className: 'milestone-wrap',

  initialize: function(options){
    this.collection = new app.collections.Activities(this.model.get('activities'));
    this.template = JST['meeting_activities_list'];
   
    this.meeting = options.meeting;
    this.meeting_id = this.meeting.get('id');

    this.listenTo(this.collection, 'add', this.addActivity);
    this.listenTo(this.collection, 'remove', this.showEmptyMessage);
  },

  render: function(){
    this.$el.html(this.template({
      milestone: this.model.toJSON()
    }));

    this.renderActivities();

    if( this.meeting.canAddActivities() ){
      this.renderForm();
    }

    return this;
  },

  addActivity: function(model){
    var activityItem = new app.views.MeetingActivityItemView({
      model: model
    });

    if(this.collection.length > 0){
      this.$('.activities-list > .empty').remove();
    }

    this.$('.activities-list').append( activityItem.render().el );
    activityItem.animateEntrance();
  },

  showEmptyMessage: function(){
    if(this.collection.length == 0){
      this.$('.activities-list').html('<div class="empty">Sin actividades</div>');
    }
  },

  renderActivities: function(){
    var container = document.createDocumentFragment();
    this.$('.activities-list').empty();

    if( this.collection.length == 0 ){
      this.$('.activities-list').html('<div class="empty">Sin actividades</div>');
    }else{
      this.collection.each(function(model, index){
        var activityItem = new app.views.MeetingActivityItemView({
          model: model
        });

        container.appendChild( activityItem.render().el );
      }, this);

      this.$('.activities-list').append(container);
    }

    return this;
  },

  renderForm: function(){
    this.form = new app.views.ActivityQuickForm({
      collection: this.collection,
      milestone_id: this.model.get('id'),
      meeting_id: this.meeting_id
    });

    this.$el.append(this.form.render().el);
    return this;
  }
});
