app.views.MilestoneShowView = Backbone.View.extend({
  events: {
    'click .new-activity-btn': 'newActivity',
    'click .edit-activity-btn': 'editActivity'
  },

  initialize: function(){

  },

  newActivity: function(){
    $('#new-activity-form .date-range').datepicker({
      inputs: $('#new-activity-form .date-range .start-date, #new-activity-form .date-range .end-date'),
      language: 'es',
      format: 'dd/mm/yyyy',
      todayBtn: 'linked',
      todayHighlight: true
    });

    var max_date = $('#new-activity-form .date-range').attr('max-date');

    $('#new-activity-form .start-date').datepicker('setEndDate', max_date);
    $('#new-activity-form .end-date').datepicker('setEndDate', max_date);

    $('#new-activity-form .date-type').on('change', this.activityDuration);
    $('#new-activity-form .start-date').on('change', this.activityDuration);
    $('#new-activity-form .end-date').on('change', this.activityDuration);

    $('#new-activity-form').modal('show');
    $('#new-activity-form input[type="text"]:first').focus();

    $('#new-activity-form').on('hidden.bs.modal', function(){
      $('#new-activity-form .date-range').datepicker('remove');
      $('#new-activity-form .date-range input').val('');
      $('#new-activity-form .duration-days').text('0 Días');

      $('#new-activity-form .date-type').off('change');
      $('#new-activity-form .start-date').off('change');
      $('#new-activity-form .end-date').off('change');

      $('#new-activity-form').off('hidden.bs.modal');
    });
  },

  editActivity: function(e){
    e.preventDefault();

    var activity_id = $(e.currentTarget).attr('activity-id');
    var activity    = new app.models.Activity({ id: activity_id});
    var self        = this;
    
    activity.fetch({
      success: function(){
        $('#edit-activity-form #activity_name').val(activity.get('name'));
        $('#edit-activity-form #activity_description').val(activity.get('description'));
        $('#edit-activity-form .with-selectize')[0].selectize.setValue(activity.get('assigned_id'));

        $('#edit-activity-form .date-range').datepicker({
          inputs: $('#edit-activity-form .start-date, #edit-activity-form .end-date'),
          language: 'es',
          format: 'dd/mm/yyyy',
          todayBtn: 'linked',
          todayHighlight: true
        });
        
        $('#edit-activity-form .start-date').datepicker( 'setDate', moment(activity.get('start_date')).format('DD/M/YYYY') );
        $('#edit-activity-form .end-date').datepicker( 'setDate', moment(activity.get('end_date')).format('DD/M/YYYY') );

        $('#edit-activity-form .date-type.' + activity.get('date_type') +'').prop('checked',true);
        $('#edit-activity-form form').attr('action', '/activities/' + activity_id);

        $('#edit-activity-form .date-type').on('change', self.activityDuration);
        $('#edit-activity-form .start-date').on('change', self.activityDuration);
        $('#edit-activity-form .end-date').on('change', self.activityDuration);

        $('#edit-activity-form').modal('show');
        $('#edit-activity-form input[type="text"]:first').focus();
        $('#edit-activity-form .start-date').trigger('change');

        $('#edit-activity-form').on('hidden.bs.modal', function(){
          $('#edit-activity-form .date-range').datepicker('remove');
          $('#edit-activity-form .date-range input').val('');
          $('#edit-activity-form .duration-days').text('0 Días');

          $('#edit-activity-form .date-type').off('change');
          $('#edit-activity-form .start-date').off('change');
          $('#edit-activity-form .end-date').off('change');

          $('#edit-activity-form').off('hidden.bs.modal');
        });
      }
    });
  },

  activityDuration: function(){
    var elapsed_work_days = function(a, b) {
      var days = b.diff(a, 'days');
      var start = a.day();
      var count = 0;
      for (var i = 0; i < days; i++) {
        start++;
        if (start > 6)
          start = 0;
        if (start > 0 && start < 6)
          count++;
      }
      return count;
    }

    var calculate_days = function(options){
      var start_date = moment(options['start_date'], 'DD/MM/YYYY');
      var end_date   = moment(options['end_date'], 'DD/MM/YYYY');
      var type       = options['type'] || 'calendar';

      if( type == 'calendar' ){
        return end_date.diff(start_date, 'days', true);
      }else{
        return elapsed_work_days(start_date, end_date)
      }
    };

    var container = $(this).parents('.modal');

    var days = calculate_days({
      start_date: container.find('.date-range .start-date').val(),
      end_date: container.find('.date-range .end-date').val(),
      type: container.find('.date-type:checked').val()
    });

    if( days < 0 ){
      days = '0 Días'
    }else{
      days += (days == 1) ? ' Día' : ' Días';
    }
  }
});
