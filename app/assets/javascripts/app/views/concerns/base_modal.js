app.views.BaseModal = Backbone.View.extend({
  className: 'modal animated pulse',

  baseEvents: {
    'hidden.bs.modal': 'remove'
  },

  template: JST['base_modal'],

  render: function(){
    this.$el.html(this.template(this.data()));
    this.$el.find('.modal-content').append(this.yield());

    this.$el.modal({
      backdrop: 'static'
    });

    this.delegateEvents( _.extend(this.events, this.baseEvents) );

    if( !_.isUndefined(this.afterRender) ){
      this.afterRender();
      this.$('input[name="authenticity_token"]').val(app.csrfToken);
    }

    return this;
  },

  yield: function(){
    return '';
  },

  data: function(){
    return {
      title: (_.isFunction(this.title)) ? _.bind(this.title, this) : this.title
    };
  },

  open: function(){
    this.$el.modal('show');
    return this;
  },

  close: function(){
    this.$el.modal('hide');
    return this;
  }
});
