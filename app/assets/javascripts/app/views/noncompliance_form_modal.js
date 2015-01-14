app.views.NoncomplianceFormModal = app.views.BaseModal.extend({
  title: 'Causa de no cumplimiento',

  className: 'modal animated pulse noncompliance-form-modal',

  events: {
    'click .constraints-list label input': 'selectConstraint'
  },

  initialize: function(options){
    this.activity = options['activity'];
    this.constraints = options['constraints'];
  },

  yield: function(){
    return JST['noncompliance_form_modal']({
      activity: this.activity.toJSON(),
      pendingConstraints: this.pendingConstraints()
    });
  },

  afterRender: function(){
    this.$('.with-selectize').selectize();
  },

  pendingConstraints: function(){
    return this.constraints
               .where({ status: 'pending' })
               .map(function(model){ 
                  return model.toJSON() 
                });
  },

  selectConstraint: function(e){
    var $li = $(e.currentTarget).parents('li');

    if( $li.hasClass('is-issue') ){
      if( $(e.currentTarget).is(':checked') ){
        $li.addClass('selected');
        this.$('.constraints-list li:not(.is-issue)').removeClass('selected');
        this.$('.constraints-list li:not(.is-issue)').addClass('disabled');
        this.$('.constraints-list li:not(.is-issue) input').prop('checked', false);
        this.$('.constraints-list li:not(.is-issue) input').prop('disabled', true);
        this.$('.issue-wrapper').removeClass('hidden');
        this.$('.issue-wrapper textarea').focus();
        this.$('.issue-wrapper textarea').prop('disabled', false);

      }else{
        $li.removeClass('selected');
        this.$('.constraints-list li:not(.is-issue)').removeClass('disabled');
        this.$('.constraints-list li:not(.is-issue) input').prop('disabled', false);
        this.$('.issue-wrapper').addClass('hidden');
        this.$('.issue-wrapper textarea').prop('disabled', true);
      }

    }else{
      if( $(e.currentTarget).is(':checked') ){
        $li.addClass('selected');
      }else{
        $li.removeClass('selected');
      }
    }
  }
});
