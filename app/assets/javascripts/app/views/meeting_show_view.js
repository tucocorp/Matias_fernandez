app.views.MeetingShowView = app.views.BaseModal.extend({
  
  events: {
    'click .activities .new-activity-btn': 'newActivity'
  },

  initialize: function(options){
    this.meeting    = options.meeting;
    this.meeting_id = this.meeting.get('id');
  },

  newActivity: function(e){
    e.preventDefault();

    var milestone_id = $(e.currentTarget).attr('milestone-id');

    var activity = new app.models.Activity({
      milestone_id: milestone_id,
      meeting_id: this.meeting_id
    });

    var activityFormModal = new app.views.ActivityFormModal({
      meeting_id: this.meeting_id,
      milestone_id: milestone_id,
      model: activity,
      members: window.members
    });

    activityFormModal.render();
    activityFormModal.open();
  },

  render: function(){
    if( $('.details'.length > 0) ){
      var $wrap = $('.details .duration .value');

      $wrap.each(function(index, item){
        var $item = $(item);

        var started_at = moment($item.attr('started-at'));
        var ended_at   = moment($item.attr('ended-at'));
        var diff       = ended_at.diff(started_at, 'milliseconds');
        var duration   = moment.duration(diff, 'milliseconds');
        
        var days    = (duration.days() == 0) ? 1 : duration.days();
        var hours   = _.pad(duration.hours(), 2, '0');
        var minutes = _.pad(duration.minutes(), 2, '0');
        var seconds = _.pad(duration.seconds(), 2, '0');

        $item.html(hours + ':' + minutes + ':' + seconds);
      });
    }

    if( $('.timer-wrapper').length > 0 ){
      var $wrap    = $('.timer-wrapper');
      var $hours   = $wrap.children('.hours');
      var $minutes = $wrap.children('.minutes');
      var $seconds = $wrap.children('.seconds');

      var started_at = moment($wrap.attr('started-at'));

      var set_timer = function(start){
        var diff       = moment().diff(start, 'milliseconds');
        var duration   = moment.duration(diff, 'milliseconds');

        var days    = duration.days();
        var hours   = _.pad(duration.hours() + (days * 24), 2, '0');
        var minutes = _.pad(duration.minutes(), 2, '0');
        var seconds = _.pad(duration.seconds(), 2, '0');

        $hours.text(hours);
        $minutes.text(minutes);
        $seconds.text(seconds);
      }

      set_timer(started_at);

      setInterval(function(){
        set_timer(started_at);
      }, 1000);
    }

    this.renderActivities();
    this.renderComments();
  },

  renderActivities: function(){
    var milestonesCollection = new app.collections.Milestones(window.milestonesActivities);
    var self = this;

    milestonesCollection.each(function(milestone){
      var meetingActivitiesList = new app.views.MeetingActivitiesList({
        model: milestone,
        meeting: self.meeting
      });

      self.$('.activities-wrapper').append(meetingActivitiesList.render().el);
    });
  },

  renderComments: function(){
    var commentsCollection = new app.collections.Comments(window.meetingComments);

    var commentsList = new app.views.CommentsList({
      collection: commentsCollection
    });

    var commentForm = new app.views.CommentFormView({
      meeting: this.meeting,
      collection: commentsCollection
    });

    this.$('.comments .panel-body').html(commentsList.render().el);
    this.$('.comments .panel-body').append(commentForm.render().el);
  }
});
