app.views.ActivityFormModal = app.views.BaseModal.extend({
  className: 'modal animated pulse activity-modal',

  events: {
    'click .effort-wrap input': 'selectInput',
    'shown.bs.modal': 'setFocus',
    'change .date-type': 'calculateDays',
    'changeDate .date-range': 'setDates',
    'changeDate .date-range': 'setDates',
    'submit form': 'saveActivity',
    'blur .btn-success': 'hideErrors'
  },

  activityBindings: {
    '.name': 'name',
    '.description': 'description',
    '.date-type': 'date_type',

    '.hidden-start-date': {
      observe: 'start_date',
      onGet: function(val){
        this.$('.date-range .start-date').datepicker('setDate', val);
      }
    },

    '.hidden-end-date': {
      observe: 'end_date',
      onGet: function(val){
        this.$('.date-range .end-date').datepicker('setDate', val)
      }
    },

    '.assigned-id': {
      observe: 'assigned_id',
      selectOptions: {
        collection: 'this.members',
      },
      selectizeOptions: {
        valueField: 'id',
        labelField: 'email',
        searchField: ['short_name', 'full_name', 'email'],
        allowEmptyOption: true,
        placeholder: 'Sin asignar'
      }
    }
  },

  initialize: function(options){
    if( _.isUndefined(this.model) ){
      throw "Must specify an Activity model";
    }else if( _.isUndefined(options.members) ){
      throw "Must specify a ProjectMembers array";
    }

    this.reload = (_.isUndefined(options.reload)) ? true : options.reload;

    this.members      = options.members;
    this.meeting_id   = options.meeting_id;
    this.milestone_id = options.milestone_id;
    this.listenTo(this.model, 'invalid', this.showErrors);
  },

  title: function(){
    if( this.model.isNew() ){
      return 'Nueva actividad';
    }else{
      return 'Editar actividad';
    }
  },

  yield: function(){
    return JST['activity_form_modal']({
      members: this.members
    });
  },

  afterRender: function(){
    this.$('.date-range').datepicker({
      inputs: this.$('.date-range .start-date, .date-range .end-date'),
      language: 'es',
      format: 'yyyy-mm-dd',
      todayBtn: 'linked',
      todayHighlight: true,
      weekStart: 1
    });

    this.$('.hidden-meeting-id').val( this.meeting_id );
    this.$('.hidden-milestone-id').val( this.milestone_id );

    this.$('.with-autosize').autosize();

    this.stickit(this.model, this.activityBindings);
  },

  setFocus: function(){
    this.$('.form-control:first').focus();
  },

  selectInput: function(e){
    $(e.currentTarget).select();
  },

  elapsedWorkDays: function(a, b) {
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
  },

  elapsedDays: function(options){
    var start_date = moment(options['start_date']);
    var end_date   = moment(options['end_date']);
    var type       = options['type'] || 'calendar';
    var total      = 0;

    if( type == 'calendar' ){
      total = end_date.diff(start_date, 'days');
    }else{
      total = this.elapsedWorkDays(start_date, end_date);
    }

    return total + 1;
  },

  calculateDays: function(){
    var options = {
      start_date: this.$('.date-range .start-date').datepicker('getDate'),
      end_date: this.$('.date-range .end-date').datepicker('getDate'),
      type: this.$('.date-type:checked').val()
    };

    var days = this.elapsedDays(options);
    this.$('.duration-days').text(days + ' días');
  },

  setDates: function(){
    var start_date = moment(this.$('.date-range .start-date').datepicker('getDate'));
    var end_date = moment(this.$('.date-range .end-date').datepicker('getDate'));

    if( start_date.isValid() && end_date.isValid() ){
      this.calculateDays();
      this.$('.hidden-start-date').val( start_date.format('YYYY-MM-DD') ).trigger('change');
      this.$('.hidden-end-date').val( end_date.format('YYYY-MM-DD') ).trigger('change');
    }
  },

  showErrors: function(model){
    var html = '<ul>';

    _.each(model.validationError, function(error){
      html += '<li>'+ error[1] +'</li>';
    });

    html += '</ul>';

    this.$('.btn-success').popover({
      animation: false,
      html: true,
      content: html,
      container: 'body',
      placement: 'auto',
      trigger: 'manual',
      title: 'No se puede guardar la actividad'
    });

    this.$('.btn-success').focus().popover('show');
  },

  hideErrors: function(e){
    this.$('.btn-success').popover('destroy');
  },

  saveActivity: function(e){
    e.preventDefault();

    this.model.save({}, {
      success: _.bind(function(){
        if( this.reload ){
          window.location.reload();
        }else{
          this.close();
          this.model.trigger('saved', this.model);
        }
      }, this)
    });
  }
});
