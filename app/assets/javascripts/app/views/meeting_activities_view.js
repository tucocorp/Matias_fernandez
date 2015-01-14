app.views.MeetingActivitiesView = Backbone.View.extend({
  initialize: function(options){
    this.meeting = options.meeting;
    this.meeting_id = this.meeting.get('id');
  },

  render: function(){
    this.setCountdown();
    this.setCountup();
  },

  setCountdown: function(){
    if( $('.countdown-timer').length > 0 ){
      var end_date = moment($('.countdown-timer').attr('ends-at'));

      var $wrap    = $('.countdown-timer');
      var $hours   = $wrap.children('.hours');
      var $minutes = $wrap.children('.minutes');
      var $seconds = $wrap.children('.seconds');

      var set_timer = function(){
        var current    = moment();
        var diff       = end_date.diff(current, 'milliseconds');
        var duration   = moment.duration(diff, 'milliseconds');

        var days    = ( duration.days() == 0 ) ? 1 : duration.days();
        var hours   = _.pad(duration.hours(), 2, '0');
        var minutes = _.pad(duration.minutes(), 2, '0');
        var seconds = _.pad(duration.seconds(), 2, '0');

        $hours.text(hours);
        $minutes.text(minutes);
        $seconds.text(seconds);
      };

      set_timer();

      setInterval(set_timer, 1000);
    }
  },

  setCountup: function(){
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
  },

  renderActivities: function(){
    var milestonesCollection = new app.collections.Milestones(window.milestonesActivities);

    milestonesCollection.each(_.bind(function(milestone){
      var meetingActivitiesList = new app.views.MeetingActivitiesList({
        model: milestone,
        meeting: this.meeting
      });

      this.$('.activities-wrapper').append(meetingActivitiesList.render().el);
    }, this));
  }
});
