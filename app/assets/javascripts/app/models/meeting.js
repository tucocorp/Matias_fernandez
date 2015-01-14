app.models.Meeting = Backbone.Model.extend({

  canAddActivities: function(){
    return (this.get('status') == 'running' && this.get('is_attendee') === true);
  }
});
