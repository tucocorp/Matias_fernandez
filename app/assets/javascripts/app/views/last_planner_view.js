app.views.LastPlannerView = Backbone.View.extend({

  events: {

  },

  initialize: function(options){
    this.project_id = options['project_id'];
  },

  render: function(){
    _.each(this.$('.activity-wrap'), function(item){
      var activity_id = $(item).attr('activity-id');

      var activityCard = new app.views.ActivityCard({
        el: $(item),
        model: new app.models.Activity({id: activity_id})
      });
    }, this);

    var date = moment($('.focal-date').attr('date-selected')).format('DD/MM/YYYY');

    $('.focal-date').datepicker({
      todayBtn: 'linked',
      todayHighlight: true
    });

    $('.focal-date').datepicker('setDate', date);

    $('.focal-date')
      .on('changeDate', function(e){
        var date    = moment(e.date).format('YYYY-MM-DD');
        var new_url = URI(window.location.href).setQuery({ date: date })

        window.location = new_url;
      });
  }
});
