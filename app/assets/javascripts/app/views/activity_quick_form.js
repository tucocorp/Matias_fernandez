app.views.ActivityQuickForm = Backbone.View.extend({
  tagName: 'form',
  className: 'activity-form',

  events: {
    'focus input': 'open',
    'click .cancel-btn': 'close',
    'submit': 'saveActivity',
    'blur .btn-success': 'hideErrors'
  },

  bindings: {
    '.activity-name': 'name',
    '.description': 'description',
    
    '.assigned-id': {
      observe: 'assigned_id',
      selectOptions: {
        collection: 'this.members'
      },
      selectizeOptions: {
        labelField: 'short_name',
        searchField: ['short_name', 'full_name', 'email'],
        valueField: 'id',
        allowEmptyOption: true
      }
    }
  },

  initialize: function(options){
    this.milestone_id = options.milestone_id;
    this.meeting_id   = options.meeting_id;
    this.members      = options.members || window.members;
    this.template     = JST['activity_quick_form'];

    this.setModel();
  },

  setModel: function(){
    this.unstickit();

    this.model = new app.models.Activity({ 
      milestone_id: this.milestone_id,
      meeting_id: this.meeting_id
    });

    this.listenTo(this.model, 'invalid', this.showErrors);
    this.stickit();
    return this;
  },

  render: function(){
    this.$el.html(this.template());
    this.stickit();

    return this;
  },

  open: function(){
    $('.activity-form').removeClass('open');
    this.$el.addClass('open');
  },

  close: function(e){
    if( !_.isUndefined(e) ){
      e.preventDefault();
    }

    this.$el.removeClass('open');
  },

  clearForm: function(){
    this.$el[0].reset();
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

    this.$('.btn-success').popover('show').focus();
  },

  hideErrors: function(e){
    this.$('.btn-success').popover('destroy');
  },

  saveActivity: function(e){
    e.preventDefault();

    this.model.save({}, {
      success: _.bind(function(response){
        this.collection.add(this.model);
        this.clearForm();
        this.setModel();
        this.$('.activity-name').focus();
      }, this)
    });
  }
});
